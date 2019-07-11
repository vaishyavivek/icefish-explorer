/* $Id: AddressBox.qml
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
import "../CustomComponents"

Item {
    id: addressBox

    TextField{
        id: textField
        width: parent.width
        height: parent.height
        text: qtModel.AddressBoxData
        onAccepted: qtModel.updateCurrentDirectory(text)

        background: Rectangle{
            border.width: 1
            border.color: textField.focus ? rFileSystem.HighlightColor : "grey"
            radius: 5
        }
    }

    ListView{
        id: listview
        width: 0
        height: parent.height
        model: qtModel.AddressBoxDataListView
        orientation: Qt.Horizontal
        layoutDirection: ListView.LeftToRight

        delegate: ItemDelegate{
            id: listviewDelegate
            height: parent.height
            width: 38
            Row{
                anchors.fill: parent
                spacing: 2
                Button{
                    id: shortcutMenuBtn
                    padding: 0
                    width: 15
                    height: parent.height
                    hoverEnabled: true
                    icon.source: "/local/assets/shortcut-menu.svg"
                    text: model.modelData.Path
                    display: AbstractButton.IconOnly
                    icon.color: hovered ? rFileSystem.HighlightColor : rFileSystem.IconColor1

                    background: Rectangle {
                        width: shortcutMenuBtn.width - 2
                        height: shortcutMenuBtn.height - 2
                        color: "transparent"
                    }

                    onClicked: {
                        qtModel.updateAddressBoxShortcutMenuList(text)
                        var shortcutMenuPopupComp = Qt.createComponent("ShortcutMenu.qml")
                        var shortcutMenuPopupObj = shortcutMenuPopupComp.createObject(shortcutMenuBtn, {"x": shortcutMenuBtn.x, "y": shortcutMenuBtn.height})
                    }
                }
                Button{
                    id: sectionMenuBtn
                    width: parent.width - 15
                    height: parent.height
                    text: model.modelData.DisplayName
                    enabled: true
                    hoverEnabled: true

                    contentItem: Rectangle{
                        color: "transparent"
                        Text {
                            id: name
                            anchors.centerIn: parent
                            text: sectionMenuBtn.text
                            font.pointSize: 10
                            color: sectionMenuBtn.hovered ? rFileSystem.HighlightColor : rFileSystem.IconColor1
                        }
                        Component.onCompleted: {
                            listviewDelegate.width = name.paintedWidth + 25
                            if(listview.width < addressBox.width)
                                listview.width += listviewDelegate.width
                            listview.contentWidth += listviewDelegate.width
                        }
                    }

                    background: Rectangle {
                        width: sectionMenuBtn .width - 2
                        height: sectionMenuBtn.height - 2
                        color: "transparent"
                    }

                    onClicked: qtModel.updateCurrentDirectory(model.modelData.Path)
                }
            }
        }

        onModelChanged: {
            contentWidth = 0
            textField.visible = false
            listview.visible = true
        }
    }

    RImageButton{
        id: switchBetweenBtn
        height: parent.height*0.75
        width: height
        anchors.right: parent.right
        anchors.rightMargin: parent.height*0.25
        anchors.verticalCenter: parent.verticalCenter
        icon.source: "/local/assets/search.svg"
        icon.color: rFileSystem.IconColor
        onClicked: {
            if(listview.visible){
                textField.visible = true
                listview.visible = false
            }
            else{
                textField.visible = false
                listview.visible = true
            }
        }
    }
}
