/* $Id: ScalePopup.qml
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

Popup{
    id: scalePopup
    width: 400
    height: 250
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle{
        color: rFileSystem.BackgroundColor
        opacity: 0.8
        border.width: 1
        border.color: rFileSystem.SelectedColor

        DropShadow{
            anchors.fill: parent
            source: parent
            horizontalOffset: 2
            verticalOffset: 2
            radius: 2
            samples: 5
            color: "#80000000"
        }
    }

    contentItem: Column{
        anchors.fill: parent
        anchors.margins: 5
        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"
            Text {
                id: originalDimensions
                width: parent.width
                height: parent.height
                text: qsTr("<b>Original Dimensions: </b>" + rPhotoDetailsModel.ImageDimensions)
                font.pointSize: 11
                font.weight: Font.Thin
                color: rFileSystem.IconColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"
            Row{
                anchors.fill: parent
                Text {
                    id: changeByPercent
                    height: parent.height
                    text: qsTr("<b>Scale by Percent: </b>" )
                    font.pointSize: 11
                    font.weight: Font.Thin
                    color: rFileSystem.IconColor
                }
            }
        }
    }
}
