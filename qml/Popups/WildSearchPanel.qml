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

Popup{
    id: wildSearchPanel
    property int oldY
    property int newY
    property string searchKey: qtModel.WildSearchKey
    padding: 2
    modal: false

    Rectangle{
        id: notificationPanelParentRect
        width: parent.width
        height: parent.height
        color: mainWindow.color
        Row{
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.fill: parent
            spacing: 5
            Text {
                id: title
                color: mainWindow.fontColor
                text: qsTr("<b>Wild Search for:</b>")
            }
            TextInput{
                id: searchArea
                text: searchKey
                color: mainWindow.fontColor
                onTextChanged: qtModel.WildSearchKey = text
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

    onClosed: {
        searchKey = ""
        qtModel.reloadCurrentDirectory()
        fileFolderView.searching = false
    }
}
