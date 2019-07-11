/* $Id: ShortcutMenu.qml
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

Popup{
    id: shortcutMenu
    property int fontSize: 10

    padding: 0

    Rectangle{
        id: shortcutMenuListViewParentRect
        height: qtModel.AddressBoxShortcutMenuListCount* (fontSize*2.5 + 3) + 10
        color: rFileSystem.BackgroundColor1
        border.color: rFileSystem.IconColor1
        border.width: 1
        radius: 5

        ListView{
            id: shortcutMenuListView
            height: parent.height - 10
            anchors.verticalCenter: parent.verticalCenter
            clip: true
            highlightFollowsCurrentItem: true
            keyNavigationEnabled: false
            spacing: 3
            model: qtModel.AddressBoxShortcutMenuList

            delegate: Rectangle{
                id: shortcutMenuListViewDelegate
                width: shortcutMenuListView.width
                height: fontSize + 15
                color: "transparent"
                radius: 5

                Text{
                    id: optionText
                    text: model.modelData.DisplayName
                    color: rFileSystem.IconColor1
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: fontSize
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }
                Text {
                    id: shortcutText
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: fontSize
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                }
                Component.onCompleted: {
                    parent.width = optionText.paintedWidth + shortcutText.paintedWidth + 25
                    if(shortcutMenuListView.width < parent.width){
                        shortcutMenuListView.width = parent.width
                        shortcutMenuListViewParentRect.width = shortcutMenuListView.width
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: mouseEnteredAnimation.start()
                    onExited: mouseExitedAnimation.start()
                    onClicked: {
                        qtModel.updateCurrentDirectory(model.modelData.Path)
                        shortcutMenu.close()
                    }
                }

                Rectangle{
                    id: animatingRect
                    width: parent.width - 10
                    height: parent.height
                    anchors.centerIn: parent
                    color: "transparent"
                    radius: 5
                    z: -1
                }

                PropertyAnimation{
                    id: mouseEnteredAnimation
                    target: animatingRect
                    property: "color"
                    to: rFileSystem.HighlightColor
                    duration: rFileSystem.GlobalAnimationDuration
                }
                PropertyAnimation{
                    id: mouseExitedAnimation
                    target: animatingRect
                    property: "color"
                    to: "transparent"
                    duration: rFileSystem.GlobalAnimationDuration
                }
            }
        }
    }

    Component.onCompleted: shortcutMenu.open()

    onClosed: shortcutMenu.destroy()
}
