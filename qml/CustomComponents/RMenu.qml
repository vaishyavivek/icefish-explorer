/* $Id: RMenu.qml
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

ToolTip{
    id: rmenu
    property bool isOpened: false
    property int actionMenuCount: 0
    property string filePath
    property variant menuList
    padding: 0
    contentHeight: actionMenuCount*29
    contentWidth: 200

    background: Rectangle{
        opacity: 0.3
        color: rFileSystem.BackgroundColor1
    }

    Rectangle{
        anchors.fill: parent
        color: rFileSystem.BackgroundColor1
        border.color: rFileSystem.IconColor1
        border.width: 1
        radius: 5

        ListView{
            id: menuListView
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent
            spacing: 3
            model: menuList

            delegate: RTextButton{
                width: menuListView.width
                height: 25
                text: (model.modelData.HasSubmenu ? "<    ": "      ")  + model.modelData.ServiceName
                alignTextCenter: false
                onClicked: {
                    if(model.modelData.HasSubmenu)
                        submenuPopup.open()
                    else{
                        var action = model.modelData.Action
                        if(action === "newtab")
                            rFileSystem.createNewTab(filePath)
                        else
                            qtModel.performAction(filePath, action)
                        rmenu.close()
                    }
                }

                ToolTip{
                    id: submenuPopup
                    property bool isOpened: false
                    property string action: model.modelData.Action
                    property variant subMenuModel: model.modelData.Submenu
                    padding: 0
                    contentWidth: 200
                    contentHeight: (model.modelData.SubmenuCount)*29
                    x: parent.x - 202
                    y: parent.y
                    background: Rectangle{
                        opacity: 0.3
                        color: rFileSystem.BackgroundColor1
                    }

                    Rectangle{
                        anchors.fill: parent
                        color: rFileSystem.BackgroundColor1
                        border.color: rFileSystem.IconColor1
                        border.width: 1
                        radius: 5

                        ListView{
                            id: submenuListView
                            width: parent.width - 10
                            height: parent.height - 10
                            anchors.centerIn: parent
                            spacing: 3
                            model: submenuPopup.subMenuModel

                            delegate: RImageExpandingButton{
                                width: submenuListView.width
                                height: 25
                                icon.source: model.modelData.ServiceIcon
                                text: model.modelData.ServiceName
                                fontColor: rFileSystem.IconColor1
                                onClicked: {
                                    qtModel.performAction(filePath, submenuPopup.action, model.modelData.DesktopFile)
                                    submenuPopup.close()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    onClosed: isOpened = false
}
