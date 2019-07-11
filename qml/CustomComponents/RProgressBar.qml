/* $Id: RProgressBar.qml
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

ProgressBar {
    id: progress
    width: parent.width
    height: parent.height
    from: 0
    to: 1

    background: Rectangle {
        z: -2
        clip: true
        color: rFileSystem.BackgroundColor2//"transparent"
        implicitWidth: parent.width
        radius: 5
    }

    contentItem: Rectangle {
        z: -2
        clip: true
        color: "transparent"
        opacity: 0.75
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: 5

        Rectangle{
            width: progress.visualPosition * parent.width
            height: parent.height
            radius: 5
            color: rFileSystem.HighlightColor
        }
    }
}
