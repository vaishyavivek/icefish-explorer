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
import "../CustomComponents"

Popup{
    id: bookmarkPanel
    padding: 0
    property int widthWhenExpanded
    property bool isOpened: false

    clip: true
    closePolicy: Popup.NoAutoClose

    Rectangle{
        id: bookmarkPanelParentRect
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
                    width: parent.width - closeBBtn.width
                    color: "transparent"
                    Text {
                        width: parent.width
                        height: parent.height
                        text: "BOOKMARKS"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 12
                        color: rFileSystem.IconColor
                    }
                }
                RImageButton{
                    id: closeBBtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    icon.source: "/local/assets/popup-close.svg"
                    icon.color: rFileSystem.IconColor
                    onClicked: {
                        isOpened = false
                        bookmarkPanel.close()
                    }
                }
            }

            Rectangle{
                height: 2
                width: parent.width
                color: "grey"
                opacity: 0.5
            }

            ListView{
                id: bookmarkList
                width: parent.width - 8
                height: parent.height - headerBar.height - 4
                anchors.horizontalCenter: parent.horizontalCenter
                model: rFileSystem.BookmarkDataList

                delegate: Rectangle{
                    id: bookmarkListDelegate
                    width: bookmarkList.width
                    height: 25
                    color: "transparent"
                    Row{
                        anchors.fill: parent
                        anchors.leftMargin: 5
                        Rectangle{
                            id: icon
                            height: parent.height
                            width: height
                            color: "transparent"
                            Image {
                                anchors.centerIn: parent
                                source: model.modelData.IconPath
                                sourceSize.width: parent.width*0.9
                                sourceSize.height: parent.height*0.9
                            }
                        }
                        Rectangle{
                            id: name
                            width: parent.width - icon.width - removeBtn.width
                            height: parent.height
                            color: "transparent"
                            Text {
                                width: parent.width
                                height: parent.height
                                text: model.modelData.DisplayName
                                font.family: "Sans Serif"
                                color: rFileSystem.IconColor
                                anchors.verticalCenter: parent.verticalCenter
                                clip: true
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }
                        }
                        RImageButton{
                            id: removeBtn
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/close.svg"
                            icon.color: rFileSystem.IconColor
                            onClicked: {
                                bookmarkListDelegate.visible = false
                                rFileSystem.writeBookmarkAsync(model.modelData.ActualPath, false)
                            }
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        z: -1
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
                        onClicked: bookmarkList.currentIndex = index
                        onDoubleClicked: {
                            updateCurrentDirectory(model.modelData.ActualPath)
                            bookmarkPanel.close()
                        }
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
                    width: bookmarkList.width
                    height: 25
                    color: rFileSystem.HighlightColor
                    opacity: 0.4
                    radius: 5

                    Rectangle{
                        width: 5
                        height: parent.height
                        color: rFileSystem.IconColor
                    }
                }
                ScrollIndicator.vertical: ScrollIndicator{}
            }
        }
    }

    enter: Transition{
        NumberAnimation{
            property: "width"
            to: bookmarkPanel.widthWhenExpanded
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

    onOpened: rFileSystem.updateStoredBookmarkList()
}
