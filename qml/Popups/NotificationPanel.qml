/*This file is part of IceFish Explorer.

    IceFish Explorer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IceFish Explorer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with IceFish Explorer. If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.7
import QtQuick.Controls 2.2
import "../CustomComponents"

Popup{
    id: notificationPanel
    property int oldY
    property int newY
    padding: 2
    modal: false

    Rectangle{
        id: notificationPanelParentRect
        width: parent.width
        height: parent.height
        color: rFileSystem.BackgroundColor1
        border.width: 1
        Column{
            anchors.fill: parent
            Rectangle{
                id: headerRect
                width: parent.width
                height: parent.height*0.4
                color: "transparent"

                Rectangle{
                    anchors.fill: parent
                    opacity: 0.3
                    color: rFileSystem.HighlightColor
                }

                Text {
                    width: parent.width
                    height: parent.height
                    text: rFileSystem.NModel.Header
                    font.family: "Sans Serif"
                    color: rFileSystem.IconColor1
                    clip: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    verticalAlignment: Text.AlignVCenter
                }
                RImageButton{
                    id: nmClosebtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    icon.source: "/local/assets/close.svg"
                    icon.color: rFileSystem.IconColor1
                    onClicked: notificationPanel.close()
                }
            }
            Rectangle{
                id: commentRect
                width: parent.width
                height: parent.height*0.6 - 2
                color: "transparent"
                Text {
                    width: parent.width
                    height: parent.height
                    text: rFileSystem.NModel.Comment
                    font.family: "Sans Serif"
                    color: rFileSystem.IconColor1
                    clip: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    enter: Transition{
        NumberAnimation{
            property: "y"
            from: oldY
            to: newY
            duration: 250
            easing.type: Easing.InOutQuad
        }
    }

    exit: Transition{
        NumberAnimation{
            property: "y"
            from: newY
            to: oldY
            duration: 250
            easing.type: Easing.OutInQuad
        }
    }

    Connections{
        target: rFileSystem.NModel
        ignoreUnknownSignals: true
        onShowNotification: notificationPanel.open()
    }
}
