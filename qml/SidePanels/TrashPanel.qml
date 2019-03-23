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
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../CustomComponents"

Popup{
    id: trashPanel
    padding: 0
    property int widthWhenExpanded
    property bool isOpened: false

    clip: true
    closePolicy: Popup.NoAutoClose

    Rectangle{
        id: trashPanelParentRect
        width: parent.width
        height: parent.height
        border.width: 1
        anchors.centerIn: parent
        color: rFileSystem.BackgroundColor

        Rectangle{
            anchors.fill: parent
            opacity: 0.2
            color: rFileSystem.HighlightColor
        }

        Column{
            id: column
            anchors.fill: parent
            spacing: 5

            Rectangle{
                height: 2
                width: parent.width
                color: "grey"
                opacity: 0.5
            }

            Rectangle{
                id: headerBar
                width: parent.width
                height: 35
                color: "transparent"
                Rectangle{
                    id: titleRect
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    height: parent.height
                    width: parent.width - closeTBtn.width
                    color: "transparent"
                    Text {
                        width: parent.width
                        height: parent.height
                        text: "TRASH"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 12
                        color: rFileSystem.IconColor
                    }
                }
                RImageButton{
                    id: closeTBtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    icon.source: "/local/assets/popup-close.svg"
                    icon.color: rFileSystem.IconColor
                    onClicked: {
                        isOpened = false
                        trashPanel.close()
                    }
                }
            }

            Rectangle{
                height: 2
                width: parent.width
                color: "grey"
                opacity: 0.5
            }

            Rectangle{
                id: globalControls
                width: parent.width - 10
                height: 35
                anchors.horizontalCenterOffset: 2
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                Row{
                    anchors.fill: parent
                    spacing: 2

                    RImageButton{
                        id: reloadBtn
                        height: parent.height
                        width: height
                        icon.source: "/local/assets/reload.svg"
                        icon.color: enabled ? rFileSystem.IconColor : "#4d26282a"
                        hoverText: "Reload"
                        onClicked: rFileSystem.prepareTrashList()
                    }

                    RImageButton{
                        id: imagePreviewBtn
                        property bool nowPreviewing: false
                        height: parent.height
                        width: height
                        icon.source: "/local/assets/folder.svg"
                        icon.color: "transparent"
                        hoverText: (nowPreviewing ? "Stop Previewing items" : "Enable Image Preview")
                        onClicked: imagePreviewBtn.nowPreviewing = !imagePreviewBtn.nowPreviewing

                        Image {
                            id: previewIndicator
                            visible: false
                            source: "/local/assets/image-preview-" + (imagePreviewBtn.nowPreviewing ? "checked" : "unchecked") + ".svg"
                            sourceSize.width: parent.width*0.5
                            sourceSize.height: parent.height*0.4
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.rightMargin: 2
                        }
                        ColorOverlay{
                            z: 2
                            anchors.fill: previewIndicator
                            source: previewIndicator
                            color: rFileSystem.IconColor
                        }
                    }

                    RTextButton{
                        id: clearAllBtn
                        height: parent.height
                        width: 60
                        text: "Clear"
                        hoverText: "Clear All"
                    }

                    TextField{
                        id: textField
                        width: parent.width - height*2 - 75
                        height: parent.height
                        placeholderText: "Search for: "
                        onTextChanged: rFileSystem.prepareTrashList(text)
                    }
                }
            }

            ListView{
                id: trashList
                property int indexBeforeUpdating: 0
                width: parent.width - 8
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height - headerBar.height - 4
                model: rFileSystem.TrashList
                clip: true

                headerPositioning: ListView.OverlayHeader
                header: Rectangle{
                    z: 2
                    width: trashList.width
                    height: 40
                    color: rFileSystem.BackgroundColor

                    Row{
                        anchors.fill: parent
                        anchors.leftMargin: 5
                        spacing: 5

                        Rectangle{
                            height: parent.height*0.9
                            width: height
                            color: "transparent"
                            Image {
                                anchors.centerIn: parent
                                source: "image://mime//file"
                                sourceSize.width: parent.width*0.9
                                sourceSize.height: parent.height*0.9
                                asynchronous: true
                            }
                        }

                        Rectangle{
                            width: parent.width - parent.height*0.9
                            height: parent.height
                            color: "transparent"
                            Text {
                                width: parent.width
                                height: parent.height
                                text: "Display Name\nDeleted Time"
                                verticalAlignment: Text.AlignVCenter
                                color: rFileSystem.IconColor
                            }
                        }
                    }
                }

                delegate: Rectangle{
                    id: trashListDelegate
                    width: trashList.width
                    height: 40
                    color: "transparent"
                    Row{
                        anchors.fill: parent
                        anchors.leftMargin: 5
                        spacing: 5

                        Rectangle{
                            height: parent.height*0.9
                            width: height
                            color: "transparent"
                            Image {
                                id: iconImage
                                anchors.centerIn: parent
                                source: (imagePreviewBtn.nowPreviewing ? "image://preview/" : "image://mime/") + model.modelData.ActualPath
                                sourceSize.width: parent.width*0.9
                                sourceSize.height: parent.height*0.9
                                asynchronous: true
                            }
                        }

                        Rectangle{
                            width: parent.width - parent.height*0.9
                            height: parent.height
                            color: "transparent"
                            Text {
                                width: parent.width
                                height: parent.height
                                text: model.modelData.DisplayName + "\n" + model.modelData.DeletedDate
                                verticalAlignment: Text.AlignVCenter
                                color: rFileSystem.IconColor
                            }
                        }
                    }

                    Rectangle{
                        id: perItemActionMenu
                        visible: (trashList.currentIndex === index)
                        height: parent.height*0.75
                        width: height*3 + 8
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        color: "transparent"

                        Row{
                            anchors.fill: parent
                            anchors.leftMargin: 2
                            anchors.rightMargin: 2
                            spacing: 2
                            RImageButton{
                                id: removeBtn
                                height: parent.height
                                width: height
                                icon.source: "/local/assets/remove.svg"
                                icon.color: rFileSystem.IconColor
                                hoverText: "Remove"
                                onClicked: {
                                    trashList.indexBeforeUpdating = index
                                    model.modelData.remove()
                                    rFileSystem.prepareRecentsList()
                                }
                            }

                            RImageButton{
                                id: recoverBtn
                                height: parent.height
                                width: height
                                icon.source: "/local/assets/recover.svg"
                                icon.color: rFileSystem.IconColor
                                hoverText: "Recover"
                                onClicked: {
                                    trashList.indexBeforeUpdating = index
                                    model.modelData.recover()
                                    rFileSystem.prepareRecentsList()
                                }
                            }

                            RImageButton{
                                id: aboutBtn
                                height: parent.height
                                width: height
                                icon.source: "/local/assets/about.svg"
                                icon.color: rFileSystem.IconColor
                                hoverText: "More Info"
                            }
                        }
                    }

                    MouseArea{
                        z: -1
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
                        onClicked: trashList.currentIndex = index
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
                highlightMoveDuration: 400

                highlight: Rectangle{
                    width: trashList.width
                    height: 50
                    color: rFileSystem.HighlightColor
                    opacity: 0.4
                    radius: 5

                    Rectangle{
                        width: 5
                        height: parent.height
                        color: rFileSystem.IconColor
                    }
                }

                onModelChanged: currentIndex = indexBeforeUpdating
            }
        }
    }

    enter: Transition{
        NumberAnimation{
            property: "width"
            to: trashPanel.widthWhenExpanded
            duration: rFileSystem.GlobalAnimationDuration*2
        }
    }

    exit: Transition{
        NumberAnimation{
            property: "width"
            to: 0
            duration: rFileSystem.GlobalAnimationDuration*2
        }
    }

    onOpened: rFileSystem.prepareTrashList()
}
