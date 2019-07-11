/* $Id: CloudAccountViewer.qml
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
    id: cloudAccountViewer
    property bool isOpened: false
    property int desiredWidth: 0
    property int desiredHeight: 0
    property var cloudObject

    padding: 0
    //margins: 0

    background: Rectangle{
        id: bgRect
        color: rFileSystem.BackgroundColor1
        border.color: rFileSystem.IconColor1
        border.width: 1
        radius: 5
        implicitWidth: parent.width
        implicitHeight: content.height

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
            anchors.fill: parent
            //anchors.topMargin: 10
            anchors.margins: 10
            spacing: 5

            Row{
                width: parent.width
                height: 80
                anchors.margins: 10
                spacing: 20

                Rectangle{
                    height: parent.height
                    width: height
                    color: "transparent"
                    radius: height*0.9

                    Image {
                        id: image
                        source: cloudObject.UserImage
                        sourceSize.height: parent.height
                        sourceSize.width: parent.width
                    }
                }

                Text {
                    width: parent.width
                    height: parent.height
                    text: qsTr(cloudObject.UserName)
                    verticalAlignment: Text.AlignVCenter
                }
            }

            RProgressBar{
                width: parent.width*0.9
                height: 10
                anchors.horizontalCenter: parent.horizontalCenter
                from: 0
                to: 1
                value: cloudObject.UsedSpace/cloudObject.AllocatedSpace
            }

            Text {
                width: parent.width
                color: Qt.darker(rFileSystem.BackgroundColor2)
                text: qsTr(cloudObject.SpaceUsage)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                width: parent.width
                color: Qt.darker(rFileSystem.BackgroundColor2)
                text: qsTr("Linked To <b>" + cloudObject.Email + "</b>")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                width: parent.width
                color: Qt.darker(rFileSystem.BackgroundColor2)
                text: qsTr("Account Type:<b> " + cloudObject.AccountType + "</b> ")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                width: parent.width
                color: Qt.darker(rFileSystem.BackgroundColor2)
                text: qsTr("Default Locale:<b> " + cloudObject.Locale + "</b> ")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            RTextButton{
                anchors.horizontalCenter: parent.horizontalCenter
                width: 150
                height: 25
                text: "Unlink account"
                font.bold: true
            }
        }
    }


    enter: Transition{
        NumberAnimation{
            property: "width"
            from: 0
            to: desiredWidth
            duration: rFileSystem.GlobalAnimationDuration
        }
        NumberAnimation{
            property: "height"
            from: 0
            to: desiredHeight
            duration: rFileSystem.GlobalAnimationDuration
        }
    }

    exit: Transition{
        NumberAnimation{
            property: "width"
            to: 0
            duration: rFileSystem.GlobalAnimationDuration
        }
        NumberAnimation{
            property: "height"
            to: 0
            duration: rFileSystem.GlobalAnimationDuration
        }
    }

    onOpened: {
        isOpened = true
    }

    onClosed: {
        isOpened = false
    }
}
