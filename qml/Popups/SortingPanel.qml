/* $Id: SortingPanel.qml
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

Popup{
    id: sortingPanel
    property bool isOpened: false
    property int oldY
    property int newY
    property string currentSelection: sortingRole.currentItem.role + " " + sortingOrder.currentItem.order

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
        height: 313
        color: "transparent"

        Column{
            anchors.margins: 10
            anchors.fill: parent
            spacing: 10

            Rectangle{
                id: sortingRoleHeader
                width: parent.width
                height: 11
                color: "transparent"
                Text {
                    width: parent.width
                    height: parent.height
                    anchors.leftMargin: 5
                    text: qsTr("Sorting Roles")
                    color: rFileSystem.IconColor
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ListView{
                id: sortingRole
                width: parent.width
                height: 114
                currentIndex: qtModel.SortingRole

                delegate: RTextButton{
                    property string role: model.role
                    text: role
                    width: parent.width
                    height: 28
                    onClicked: sortingRole.currentIndex = index
                    checked: sortingRole.currentIndex == index
                }

                model: ListModel{
                    ListElement{ role: "Name"}
                    ListElement{ role: "Type"}
                    ListElement{ role: "Size"}
                    ListElement{ role: "Time"}
                }
            }

            Rectangle{
                id: sortingOrderHeader
                width: parent.width
                height: 11
                color: "transparent"
                Text {
                    width: parent.width
                    height: parent.height
                    anchors.leftMargin: 5
                    text: qsTr("Sorting Order")
                    color: rFileSystem.IconColor
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ListView{
                id: sortingOrder
                width: parent.width
                height: 28
                orientation: Qt.Horizontal
                currentIndex: qtModel.SortingOrder

                delegate: RImageButton{
                    property string order: model.order
                    icon.source: image
                    width: sortingOrder.width/2
                    height: 28
                    onClicked: sortingOrder.currentIndex = index
                    checked: sortingOrder.currentIndex == index
                }

                model: ListModel{
                    ListElement{
                        image: "/local/assets/sort-up.svg"
                        order: "Ascending"
                    }
                    ListElement{
                        image: "/local/assets/sort-down.svg"
                        order: "Descending"
                    }
                }
            }

            Rectangle{
                id: sortingPreferenceHeader
                width: parent.width
                height: 11
                color: "transparent"
                Text {
                    width: parent.width
                    height: parent.height
                    anchors.leftMargin: 5
                    text: qsTr("Sorting Preference")
                    color: rFileSystem.IconColor
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ListView{
                id: sortingPreference
                width: parent.width
                height: 28
                orientation: Qt.Horizontal
                currentIndex: qtModel.SortingPreference

                delegate: RImageButton{
                    icon.source: preference
                    width: sortingPreference.width/2
                    height: 28
                    onClicked: sortingPreference.currentIndex = index
                    checked: sortingPreference.currentIndex == index
                }

                model: ListModel{
                    ListElement{ preference: "/local/assets/folder.svg"}
                    ListElement{ preference: "/local/assets/file.svg"}
                }
            }

            RTextButton{
                width: parent.width
                height: 30
                text: "Apply"
                onClicked: {
                    qtModel.SortingRole = sortingRole.currentIndex
                    qtModel.SortingOrder = sortingOrder.currentIndex
                    qtModel.SortingPreference = sortingPreference.currentIndex
                    qtModel.reloadCurrentDirectory()
                    isOpened = false
                    sortingPanel.close()
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

    onClosed: isOpened = false
}
