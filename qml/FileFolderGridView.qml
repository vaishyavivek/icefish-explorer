/*This file is part of IceFish Explorer.

    IceFish Explorer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IceFish Explorer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with IceFish Explorer. If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.8
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import "CustomComponents"

Component{
    GridView{
        id: fileFolderGridView
        property int iconWidth: scaleFactor

        anchors.fill: parent
        anchors.margins: 10
        clip: true
        keyNavigationEnabled: true
        model: qtModel.FileFolderList
        cellWidth: scaleFactor*2
        cellHeight: scaleFactor*3

        delegate: Rectangle{
            id: fileFolderGridViewDelegate
            property variant filePath: model.modelData.Path
            property variant menuModel: model.modelData.ActionsMenu
            width: fileFolderGridView.cellWidth*0.75
            height: fileFolderGridView.cellHeight*0.75
            color: "transparent"

            RCheckBox{
                id: check
                height: 15
                width: 15
                checked: model.modelData.Selected || selectAll.checked
                onCheckedChanged: {
                    model.modelData.Selected = checked
                }
            }

            Column{
                anchors.margins: 5
                anchors.fill: parent
                spacing: 5

                Rectangle{
                    id: iconRect
                    width: parent.width
                    height: width
                    color: "transparent"
                    Image {
                        id: iconImage
                        anchors.centerIn: parent
                        source: (imagePreviewBtn.nowPreviewing ? "image://preview/" : "image://mime/") + model.modelData.FileType
                        sourceSize.width: parent.width*0.9
                        sourceSize.height: parent.height*0.9
                        asynchronous: true
                    }

                    ColorOverlay{
                        anchors.fill: iconImage
                        source: iconImage
                        color: model.modelData.IsHidden ? "#81abc7" : "transparent"
                    }
                }

                Rectangle{
                    id: displayName
                    width: parent.width
                    height: parent.height - iconRect.height - 5
                    color: "transparent"
                    clip: true
                    TextInput {
                        id: nameInput
                        text: model.modelData.DisplayName
                        font.family: "Arial"
                        horizontalAlignment: Text.AlignHCenter
                        color: rFileSystem.IconColor1
                        font.pointSize: Math.max(scaleFactor*0.16, 10)
                        anchors.verticalCenter: parent.verticalCenter
                        //anchors.horizontalCenter: parent.horizontalCenter
                        //wrapMode: Text.WrapAnywhere

                        readOnly: true
                        validator: RegExpValidator{regExp: /^[-\w^&'@{}[\],$=!#().%+~ ]+$/}
                        onAccepted: {
                            model.modelData.DisplayName = text
                            readOnly = true
                            focus = false
                        }
                        onFocusChanged: fileFolderGridView.currentIndex = index
                    }
                }
            }

            ToolTip{
                id: perItemActionMenu
                visible: false//(fileFolderGridView.currentIndex === index && !selectAll.checked)
                y: parent.height
                x: 0
                height: scaleFactor
                width: height*3
                padding: 0
                closePolicy: Popup.CloseOnPressOutside
                modal: false

                Rectangle{
                    anchors.fill: parent
                    color: "transparent"

                    Rectangle{
                        anchors.fill: parent
                        opacity: 0.3
                        color: rFileSystem.BackgroundColor
                    }

                    Row{
                        anchors.fill: parent
                        RImageButton{
                            id: renameBtn
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/rename.svg"
                            icon.color: rFileSystem.IconColor
                            hoverText: "Rename"
                            onClicked: {
                                nameInput.readOnly = false
                                editing = true
                                nameInput.selectAll()
                                nameInput.forceActiveFocus()
                            }
                        }
                        RImageButton{
                            id: deleteBtn
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/trash.svg"
                            icon.color: rFileSystem.IconColor
                            hoverText: "Delete"
                            onClicked: qtModel.deleteFile(index)
                        }
                        RImageButton{
                            id: actionBtn
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/switch.svg"
                            icon.color: rFileSystem.IconColor
                            hoverText: "More Actions"
                            onClicked: {
                                model.modelData.ActionsMenu = qtModel.getActionMenuFor(model.modelData.Path)
                                actionMenu.open()
                            }

                            RMenu{
                                id: actionMenu
                                menuList: model.modelData.ActionsMenu
                                filePath: model.modelData.Path
                                height: (model.modelData.ActionsMenuCount)*26
                                width: 200
                                clip: true
                                x: propertiesBtn.x - 220
                                y: propertiesBtn.y + propertiesBtn.height
                            }
                        }
                    }
                }
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                z: -1
                onEntered: mouseEnteredAnimation.start()
                onExited: mouseExitedAnimation.start()
                onClicked: {
                    fileFolderGridView .currentIndex = index
                    if(mouse.button == Qt.RightButton)
                        perItemActionMenu.visible = true
                }
                onDoubleClicked: updateModel(model.modelData.Path, index)
            }

            Rectangle{
                id: animatingRect
                anchors.fill: parent
                radius: 5
                opacity: 0.25
                color: "transparent"
            }


            PropertyAnimation{
                id: mouseEnteredAnimation
                target: animatingRect
                property: "color"
                easing.type: Easing.OutInQuad
                to: rFileSystem.HighlightColor
                duration: rFileSystem.GlobalAnimationDuration
            }
            PropertyAnimation{
                id: mouseExitedAnimation
                target: animatingRect
                property: "color"
                easing.type: Easing.OutInQuad
                to: "transparent"
                duration: rFileSystem.GlobalAnimationDuration
            }
        }


        highlightFollowsCurrentItem: true
        //highlightMoveVelocity: -1
        highlightMoveDuration: tabViewDelegate.highlightMoveDuration

        highlight: Rectangle{
            width: fileFolderGridView.cellWidth
            height: fileFolderGridView.cellHeight
            color: rFileSystem.SelectedColor
            opacity: 0.75
            radius: 5
        }

        onModelChanged: {
            if(!fileFolderGridView.focus)
                fileFolderGridView.forceActiveFocus()
        }

        onCurrentIndexChanged: {
            fileFolderView.currentIndexForReloading = currentIndex
            editing = false
        }

        Keys.onPressed: {
            if(!editing){
                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                    updateModel(currentItem.filePath, currentIndex)
                else if(event.key === Qt.Key_Backspace){
                    if(searching)
                        wildSearchPanel.searchKey = wildSearchPanel.searchKey.substring(0, wildSearchPanel.searchKey.length - 1)
                    else if(backBtn.enabled)
                        navigateBackward()
                }
                else if(event.key >= Qt.Key_A && event.key <= Qt.Key_Z){
                    searching = true
                    wildSearchPanel.searchKey += String.fromCharCode(event.key)
                    wildSearchPanel.open()
                }
            }
        }

        Connections{
            target: fileFolderView
            ignoreUnknownSignals: true
            onCurrentIndexChanged: fileFolderGridView.currentIndex = fileFolderView.currentIndex
        }
    }
}


