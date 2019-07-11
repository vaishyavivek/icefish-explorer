/* $Id: RWindowControlBar.qml
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

Rectangle{
    id: windowControlBar
    width: height*3 + 4
    height: 35
    anchors.verticalCenter: parent.verticalCenter
    color: "transparent"
    Row{
        anchors.fill: parent
        anchors.margins: 2
        RImageButton{
            id: minimizeWindowBtn
            height: parent.height
            width: height
            hoverText: "Minimize"
            icon.source: "/local/assets/window-minimize.svg"
            icon.color: rFileSystem.IconColor2
            onClicked: showMinimized()
        }
        RImageButton{
            id: maximizeWindowBtn
            property bool windowState: false
            height: parent.height
            width: height
            hoverText: "Full Window"
            icon.source: "/local/assets/window-full.svg"
            icon.color: rFileSystem.IconColor2
            onClicked: {
                if(windowState){
                    showNormal()
                    icon.source = "/local/assets/window-full.svg"
                }
                else{
                    showMaximized()
                    icon.source= "/local/assets/window-half.svg"
                }
                windowState = !windowState
            }
        }
        RImageButton{
            id: closeWindowBtn
            height: parent.height
            width: height
            hoverText: "Close"
            icon.source: "/local/assets/window-close.svg"
            icon.color: "#F80808"
            onClicked: Qt.quit()
        }
    }
}
