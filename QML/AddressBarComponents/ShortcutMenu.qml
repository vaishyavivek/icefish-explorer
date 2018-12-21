/*This file is part of reverse-file-manager.

    reverse-file-manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    reverse-file-manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with reverse-file-manager. If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.7
import QtQuick.Controls 2.2

Popup{
    id: shortcutMenu
    property int fontSize: 10

    padding: 1

    Rectangle{
        id: shortcutMenuListViewParentRect
        height: qtModel.AddressBoxShortcutMenuListCount*fontSize*1.7
        color: rFileSystem.BackgroundColor
        border.color: rFileSystem.IconColor
        border.width: 1
        //radius: 5
        ListView{
            id: shortcutMenuListView
            anchors.margins: 2
            height: parent.height
            clip: true
            highlightFollowsCurrentItem: true
            keyNavigationEnabled: false
            model: qtModel.AddressBoxShortcutMenuList
            delegate: Rectangle{
                id: shortcutMenuListViewDelegate
                width: shortcutMenuListView.width
                height: fontSize + 7
                color: "transparent"
                Text{
                    id: optionText
                    text: model.modelData.DisplayName
                    color: rFileSystem.IconColor
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

                PropertyAnimation{
                    id: mouseEnteredAnimation
                    target: shortcutMenuListViewDelegate
                    property: "color"
                    to: "lightblue"
                    duration: 250
                }
                PropertyAnimation{
                    id: mouseExitedAnimation
                    target: shortcutMenuListViewDelegate
                    property: "color"
                    to: "transparent"
                    duration: 250
                }
            }
        }
    }

    Component.onCompleted: shortcutMenu.open()

    onClosed: shortcutMenu.destroy()
}
