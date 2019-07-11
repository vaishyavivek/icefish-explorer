/* $Id: RImageButton.qml
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

Button {
    id: rButton
    property string hoverText: ""
    property bool toolTipEnabled: hoverText.length > 0

    hoverEnabled: true
    padding: 0
    icon.color: "transparent"

    contentItem: Rectangle{
        width: rButton.width
        height: rButton.height
        color: "transparent"
        Image{
            id: image
            visible: false
            source: icon.source
            sourceSize.width: parent.width*0.5
            sourceSize.height: parent.height*0.5
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
        }

        ColorOverlay{
            anchors.fill: image
            source: image
            color: rButton.icon.color
            //opacity: 0.5
        }
    }

    background: Rectangle {
        id: backgroundRect
        width: rButton.width - 2
        height: rButton.height - 2
        anchors.centerIn: parent
        opacity: enabled ? 1 : 0.5
        radius: 5
        color: "transparent"
    }

    ParallelAnimation{
        id: mouseEnteredAnimation
        PropertyAnimation{
            target: image
            property: "sourceSize.width"
            to: rButton.width*0.75
            duration: rFileSystem.GlobalAnimationDuration
        }

        PropertyAnimation{
            target: image
            property: "sourceSize.height"
            to: rButton.height*0.75
            duration: rFileSystem.GlobalAnimationDuration
        }

        /*Highlight animations
        PropertyAnimation{
            target: backgroundRect
            property: "color"
            to: rFileSystem.HighlightColor
            duration: rFileSystem.GlobalAnimationDuration
        }
        PropertyAnimation{
            target: backgroundRect
            property: "opacity"
            to: 0.5
            duration: rFileSystem.GlobalAnimationDuration
        }*/
    }


    ParallelAnimation{
        id: mouseExitedAnimation
        PropertyAnimation{
            target: image
            property: "sourceSize.width"
            to: rButton.width*0.5
            duration: rFileSystem.GlobalAnimationDuration
        }

        PropertyAnimation{
            target: image
            property: "sourceSize.height"
            to: rButton.height*0.5
            duration: rFileSystem.GlobalAnimationDuration
        }
        /* Highlight animations
        PropertyAnimation{
            target: backgroundRect
            property: "color"
            to: "transparent"
            duration: rFileSystem.GlobalAnimationDuration
        }
        PropertyAnimation{
            target: backgroundRect
            property: "opacity"
            to: 1
            duration: rFileSystem.GlobalAnimationDuration
        }*/
    }


    PropertyAnimation{
        id: checkedAnimation
        target: backgroundRect
        property: "color"
        to: rFileSystem.SelectedColor
        duration: rFileSystem.GlobalAnimationDuration
    }


    ParallelAnimation{
        id: mouseExitedAnimationOnChecked
        PropertyAnimation{
            target: backgroundRect
            property: "color"
            to: rFileSystem.SelectedColor
            duration: rFileSystem.GlobalAnimationDuration
        }
        PropertyAnimation{
            target: backgroundRect
            property: "opacity"
            to: 1
            duration: rFileSystem.GlobalAnimationDuration
        }

        PropertyAnimation{
            target: image
            property: "sourceSize.width"
            to: rButton.width*0.5
            duration: rFileSystem.GlobalAnimationDuration
        }

        PropertyAnimation{
            target: image
            property: "sourceSize.height"
            to: rButton.height*0.5
            duration: rFileSystem.GlobalAnimationDuration
        }
    }



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

    onHoveredChanged: {
        if(hovered)
            mouseEnteredAnimation.start()
        else if(!checked)
            mouseExitedAnimation.start()
        else
            mouseExitedAnimationOnChecked.start()
    }

    onCheckedChanged: checked ? checkedAnimation.start() : mouseExitedAnimation.start()

}
