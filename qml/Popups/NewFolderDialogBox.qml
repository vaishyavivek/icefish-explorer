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
import QtQuick.Controls 2.3
import "../CustomComponents"

Dialog{
    id: newFolderDialogBox
    property string currentPath
    property int retryCounter: 0

    modal: true
    dim: false

    closePolicy: Popup.NoAutoClose

    header: Item{
        width: newFolderDialogBox.header.width
        height: 25
        Rectangle{
            anchors.fill: parent
            opacity: 0.2
            color: "#95bcc8"
        }

        Text {
            width: parent.width
            height: parent.height
            text: newFolderDialogBox.title
            font.family: "Sans Serif"
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 8
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }

    contentItem: Item{
        width: newFolderDialogBox.width
        height: 70

        Rectangle{
            width: parent.width
            height: parent.height
            color: "transparent"
            Column{
                anchors.fill: parent
                Text {
                    width: parent.width
                    height: 30
                    text: qsTr("Create New Folder in: \n" + currentPath)
                }

                TextField{
                    id: fileNameInput
                    width: parent.width
                    height: 30
                    text: "New Folder"
                    onFocusChanged: if(focus) selectAll()
                    Connections{
                        target: qtModel
                        ignoreUnknownSignals: true
                        onCreateNew_ChooseAnother: {
                            fileNameInput.text = suggestedName
                            fileNameInput.forceActiveFocus()
                        }
                    }
                }
            }
        }
    }
    
    footer: Item{
        height: 40
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            RTextButton{
                text: "Create"
                height: 30
                width: 50
                onClicked: {
                    if(qtModel.createNewFolder(fileNameInput.text)){
                        fileNameInput.text = "New Folder"
                        newFolderDialogBox.close()
                    }
                }
            }
            RTextButton{
                text: "Cancel"
                height: 30
                width: 50
                onClicked: newFolderDialogBox.reject()
            }
        }
    }

    onOpened: fileNameInput.forceActiveFocus()
}
