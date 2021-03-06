/* $Id: RecentsPanel.qml
 * IceFish Explorer is a free File Manager for Linux Desktops for managing
 * local files as well as files on cloud, Dropbox, Onedrive, Googledrive.
 * Additionally, it also serves as a multimedia explorer for your photos,
 * music, videos, documents and other files by providing built-in plugins
 * to open them.
 * © IceFish Community, 2019
 *
 * This file is part of IceFish Explorer.
 *
 * IceFish Explorer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * IceFish Explorer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with IceFish Explorer.
 * If not, see <http://www.gnu.org/licenses/>.
 *
 * The project is hosted here,
 * http://www.icefish.tech/index/explorer/0-5
*/

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import "../CustomComponents"

ToolTip{
    id: recentsPanel
    padding: 0
    property int widthWhenExpanded
    property bool isOpened: false

    clip: true
    closePolicy: Popup.NoAutoClose
    contentWidth: widthWhenExpanded

    background: Rectangle{
        id: bgRect
        color: rFileSystem.BackgroundColor1
        border.color: rFileSystem.IconColor1
        border.width: 1
        radius: 5
        width: parent.width
        height: content.height

        RectangularGlow{
            id: effect
            z: -1
            anchors.fill: parent
            glowRadius: 5
            spread: 0.5
            color: rFileSystem.BackgroundColor2
            cornerRadius: parent.radius + glowRadius
        }
    }

    Rectangle{
        id: content
        width: parent.width
        height: parent.height
        color: "transparent"
        visible: isOpened

        Column{
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent
            spacing: 5

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
                    width: parent.width - closeRBtn.width
                    color: "transparent"
                    Text {
                        width: parent.width
                        height: parent.height
                        text: "RECENTS"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 12
                        color: rFileSystem.IconColor1
                    }
                }
                RImageButton{
                    id: closeRBtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    icon.source: "/local/assets/popup-close.svg"
                    icon.color: rFileSystem.IconColor1
                    onClicked: {
                        isOpened = false
                        recentsPanel.close()
                    }
                }
            }

            Rectangle{
                color: rFileSystem.BackgroundColor2
                opacity: 0.1
                height: 2
                width: parent.width - 10
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ListView{
                id: recentsList
                width: parent.width - 8
                height: parent.height - headerBar.height - 4
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                model: rFileSystem.RecentsList

                delegate: Rectangle{
                    id: recentsListDelegate
                    width: recentsList.width
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
                                source: "image://mime/" + model.modelData.ActualPath
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
                                color: rFileSystem.IconColor1
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
                            icon.color: rFileSystem.IconColor1
                            onClicked: {
                                recentsListDelegate.visible = false
                                //rFileSystem.writeBookmarkAsync(model.modelData.ActualPath, false)
                            }
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        z: -1
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
                        onClicked: recentsList.currentIndex = index
                        onDoubleClicked: {
                            updateCurrentDirectory(model.modelData.ActualPath)
                            recentsPanel.close()
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
                    width: recentsList.width
                    height: 25
                    color: rFileSystem.HighlightColor
                    opacity: 0.4
                    radius: 5

                    Rectangle{
                        width: 5
                        height: parent.height
                        color: rFileSystem.IconColor1
                    }
                }
                ScrollIndicator.vertical: ScrollIndicator{}
            }
        }
    }

    enter: Transition{
        NumberAnimation{
            property: "width"
            to: recentsPanel.widthWhenExpanded
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

    onOpened: rFileSystem.prepareRecentsList()
}
