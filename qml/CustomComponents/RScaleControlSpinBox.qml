/* $Id: RScaleControlSpinBox.qml
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

SpinBox {
    id: scaleControl
    property string hoverText: ""
    property bool toolTipEnabled: hoverText.length > 0

    from: 0
    to: items.length - 1
    value: 1
    hoverEnabled: true
    padding: 2
    background: rFileSystem.BackgroundColor

    property var items: ["Tiny", "Small", "Medium", "Big", "Large"]
    property var itemsInt: [16, 32, 48, 64, 80]

    validator: RegExpValidator {
        regExp: new RegExp("(Tiny|Small|Optimum|Big|Large)", "i")
    }

    textFromValue: function(value) {
        return items[value];
    }

    valueFromText: function(text) {
        for (var i = 0; i < items.length; ++i) {
            if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                return i
        }
        return sb.value
    }

    property var getValue: function(){
        return itemsInt[value]
    }

    property var setValue: function(newValue){
        return itemsInt.indexOf(newValue)
    }

    contentItem: Text{
        color: rFileSystem.IconColor1
        text: scaleControl.textFromValue(scaleControl.value, scaleControl.locale)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }


    up.indicator: RTextButton{
        x: scaleControl.mirrored ? 0 : parent.width - width
        width: scaleControl.width*0.25
        height: scaleControl.height
        text: "+"
        onClicked: scaleControl.increase()
    }

    down.indicator: RTextButton{
        x: scaleControl.mirrored ? parent.width - width : 0
        width: scaleControl.width*0.25
        height: scaleControl.height
        text: "-"
        onClicked: scaleControl.decrease()
    }

    /*up.indicator: Rectangle {
        x: scaleControl.mirrored ? 0 : parent.width - width
        width: scaleControl.width*0.25
        height: scaleControl.height
        color: scaleControl.up.pressed ? rFileSystem.SelectedColor : "transparent"
        border.color: rFileSystem.IconColor1
        opacity: enabled ? 1 : 0.5

        Text {
            text: "+"
            font.pointSize: scaleControl.height*0.75
            color: scaleControl.up.pressed ? rFileSystem.SelectedColor : rFileSystem.IconColor1
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    }*/

    /*down.indicator: Rectangle {
        x: scaleControl.mirrored ? parent.width - width : 0
        height: parent.height
        implicitWidth: scaleControl.width/3 - 5
        implicitHeight: scaleControl.height
        color: scaleControl.down.pressed ? "lightblue" : "transparent"
        border.color: enabled ? rFileSystem.IconColor1 : "black"
        Text {
            text: "-"
            font.pointSize: scaleControl.height*0.75
            color: scaleControl.down.pressed ? "skyblue" : rFileSystem.IconColor1
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }*/

    ToolTip{
        id: tooltip
        visible: toolTipEnabled && parent.hovered
        text: hoverText
        delay: 500
        timeout: 1000
        contentItem: Text {
            text: tooltip.text
            font: tooltip.font
            color: rFileSystem.IconColor2
        }
        background: Rectangle {
            radius: 5
            color: rFileSystem.BackgroundColor2
            opacity: 0.75
        }
    }
}
