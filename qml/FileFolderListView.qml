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
    //property alias currentIndex: fileFolderListView.currentIndex
    ListView{
        id: fileFolderListView

        property int chechboxWidth: scaleFactor*0.5
        property int iconWidth: scaleFactor
        property int fileNameWidth: (width - scaleFactor*1.5)*0.29
        property int lastModifiedWidth: (width - scaleFactor*1.5)*0.19
        property int sizeWidth: (width - scaleFactor*1.5)*0.19
        property int typeWidth: (width - scaleFactor*1.5)*0.2

        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        clip: true
        keyNavigationEnabled: true
        model: qtModel.FileFolderList
        //currentIndex: fileFolderView.currentIndex

        header: Rectangle{
            width: parent.width
            height: scaleFactor
            color: rFileSystem.BackgroundColor1
            z: 2

            Row{
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 10

                Rectangle{
                    id: space
                    height: parent.height*0.5
                    width: fileFolderListView.chechboxWidth + fileFolderListView.iconWidth + 10
                    color: "transparent"
                }

                Rectangle{
                    width: fileFolderListView.fileNameWidth
                    height: parent.height
                    color: "transparent"
                    clip: true

                    Text{
                        text: "File Name"
                        font.family: "Sans Serif"
                        color: rFileSystem.IconColor
                        font.pointSize: Math.max(scaleFactor*0.32, 10)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle{
                        width: 1
                        height: parent.height*0.9
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        color: rFileSystem.HighlightColor
                        Drag.active: fileNameDrag.drag.active
                        MouseArea{
                            id: fileNameDrag
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: cursorShape = Qt.SizeHorCursor
                            onPressed: parent.anchors.right = undefined
                            onReleased: parent.anchors.right = parent.parent.right
                            drag.target: parent
                        }

                        onXChanged: if(x > 0) fileFolderListView.fileNameWidth = x
                    }
                }


                Rectangle{
                    width: fileFolderListView.lastModifiedWidth
                    height: parent.height
                    color: "transparent"
                    clip: true
                    Text{
                        text: "Last Modified"
                        font.family: "Sans Serif"
                        color: rFileSystem.IconColor
                        font.pointSize: Math.max(scaleFactor*0.32, 10)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle{
                        width: 1
                        height: parent.height*0.9
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        color: rFileSystem.HighlightColor
                        Drag.active: lastModifiedDrag.drag.active
                        MouseArea{
                            id: lastModifiedDrag
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: cursorShape = Qt.SizeHorCursor
                            onPressed: parent.anchors.right = undefined
                            onReleased: parent.anchors.right = parent.parent.right
                            drag.target: parent
                        }

                        onXChanged: if(x > 0) fileFolderListView.lastModifiedWidth = x
                    }
                }

                Rectangle{
                    width: fileFolderListView.sizeWidth
                    height: parent.height
                    color: "transparent"
                    clip: true
                    Text{
                        text: "Size"
                        font.family: "Sans Serif"
                        color: rFileSystem.IconColor
                        font.pointSize: Math.max(scaleFactor*0.32, 10)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle{
                        width: 1
                        height: parent.height*0.9
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        color: rFileSystem.HighlightColor
                        Drag.active: sizeDrag.drag.active
                        MouseArea{
                            id: sizeDrag
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: cursorShape = Qt.SizeHorCursor
                            onPressed: parent.anchors.right = undefined
                            onReleased: parent.anchors.right = parent.parent.right
                            drag.target: parent
                        }

                        onXChanged: if(x > 0) fileFolderListView.sizeWidth = x
                    }
                }

                Rectangle{
                    width: fileFolderListView.typeWidth
                    height: parent.height
                    color: "transparent"
                    clip: true
                    Text{
                        text: "Type"
                        font.family: "Sans Serif"
                        color: rFileSystem.IconColor
                        font.pointSize: Math.max(scaleFactor*0.32, 10)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle{
                        width: 1
                        height: parent.height*0.9
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        color: rFileSystem.HighlightColor
                        Drag.active: typeDrag.drag.active
                        MouseArea{
                            id: typeDrag
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: cursorShape = Qt.SizeHorCursor
                            onPressed: parent.anchors.right = undefined
                            onReleased: parent.anchors.right = parent.parent.right
                            drag.target: parent
                        }

                        onXChanged: if(x > 0) fileFolderListView.typeWidth = x
                    }
                }
            }
        }

        headerPositioning: ListView.OverlayHeader

        delegate: Rectangle{
            id: fileFolderListviewDelegate
            property variant filePath: model.modelData.Path
            property variant menuModel: model.modelData.ActionsMenu
            width: parent.width
            height: scaleFactor
            color: "transparent"

            Row{
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 10

                RCheckBox{
                    id: check
                    height: fileFolderListView.chechboxWidth
                    width: fileFolderListView.chechboxWidth
                    checked: model.modelData.Selected || selectAll.checked
                    onCheckedChanged: {
                        model.modelData.Selected = checked
                        checked ? selectionCount++ : selectionCount--
                    }
                }

                Rectangle{
                    id: iconRect
                    height: parent.height*0.9
                    width: fileFolderListView.iconWidth
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
                    width: fileFolderListView.fileNameWidth
                    height: parent.height
                    color: "transparent"
                    clip: true
                    TextInput {
                        id: nameInput
                        text: model.modelData.DisplayName
                        font.family: "Sans Serif"
                        color: rFileSystem.IconColor
                        font.pointSize: Math.max(scaleFactor*0.32, 8)
                        anchors.verticalCenter: parent.verticalCenter

                        readOnly: true
                        validator: RegExpValidator{regExp: /^[-\w^&'@{}[\],$=!#().%+~ ]+$/}
                        onAccepted: {
                            model.modelData.DisplayName = text
                            readOnly = true
                            focus = false
                        }
                        onFocusChanged: fileFolderListView.currentIndex = index

                    }
                }

                Rectangle{
                    id: dateTime
                    width: fileFolderListView.lastModifiedWidth
                    height: parent.height
                    color: "transparent"
                    Text {
                        width: parent.width
                        height: parent.height
                        text: model.modelData.Date_Time_Modified
                        color: rFileSystem.IconColor
                        font.family: "Sans Serif"
                        font.pointSize: Math.max(scaleFactor*0.32, 8)
                        anchors.verticalCenter: parent.verticalCenter
                        clip: true
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle{
                    id: size
                    width: fileFolderListView.sizeWidth
                    height: parent.height
                    color: "transparent"
                    Text {
                        width: parent.width
                        height: parent.height
                        text: model.modelData.FileSize
                        color: rFileSystem.IconColor
                        font.family: "Sans Serif"
                        font.pointSize: Math.max(scaleFactor*0.32, 8)
                        anchors.verticalCenter: parent.verticalCenter
                        clip: true
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle{
                    id: type
                    width: fileFolderListView.typeWidth
                    height: parent.height
                    color: "transparent"

                    /*MimeInfoProvider{
                        id: mip
                        FilePath: model.modelData.Path
                    }*/

                    Text {
                        width: parent.width
                        height: parent.height
                        text: model.modelData.FileType
                        color: rFileSystem.IconColor
                        font.family: "Sans Serif"
                        font.pointSize: Math.max(scaleFactor*0.32, 8)
                        anchors.verticalCenter: parent.verticalCenter
                        clip: true
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            Rectangle{
                id: perItemActionMenu
                visible: (fileFolderListView.currentIndex === index && !selectAll.checked)
                height: parent.height
                width: height*3 + 10
                color: "transparent"
                anchors.right: parent.right

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
                            x: propertiesBtn.x - 220
                            y: propertiesBtn.y + propertiesBtn.height
                        }
                    }
                }
            }


            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                z: -1
                onEntered: mouseEnteredAnimation.start()
                onExited: mouseExitedAnimation.start()
                onClicked: fileFolderListView.currentIndex = index
                onDoubleClicked: updateModel(model.modelData.Path, index)
            }

            Rectangle{
                id: animatingRect
                anchors.fill: parent
                radius: 5
                opacity: 0.3
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
        highlightMoveVelocity: -1
        highlightMoveDuration: tabViewDelegate.highlightMoveDuration

        highlight: Rectangle{
            width: fileFolderListView.width
            height: scaleFactor
            color: rFileSystem.SelectedColor
            opacity: 0.4
            radius: 5
            Rectangle{
                width: 5
                height: parent.height
                color: rFileSystem.IconColor
            }
        }

        ScrollIndicator.vertical: ScrollIndicator{}

        onCurrentItemChanged: tabViewDelegate.currentItem = currentItem

        onCurrentIndexChanged: {
            fileFolderView.currentIndexForReloading = currentIndex
            editing = false
        }

        onModelChanged: {
            if(!fileFolderListView.focus)
                fileFolderListView.forceActiveFocus()
        }

        Connections{
            target: fileFolderView
            ignoreUnknownSignals: true
            onCurrentIndexChanged: {
                //console.log("some")
                fileFolderListView.currentIndex = fileFolderView.currentIndex
            }
        }
    }
}


