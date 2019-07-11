/* $Id: NewFileDialogBox.qml
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
import "../CustomComponents"

Dialog{
    id: newFolderDialogBox
    property string currentPath

    header: Item{
        width: newFolderDialogBox.header.width
        height: 25
        Rectangle{
            anchors.fill: parent
            opacity: 0.3
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
                    text: qsTr("Create New File in: \n" + currentPath)
                }

                Row{
                    width: parent.width
                    height: 30
                    spacing: 2
                    TextField{
                        id: fileNameInput
                        width: parent.width*0.7
                        height: parent.height
                        text: "New File"
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
                    RComboBox{
                        id: fileType
                        width: parent.width*0.3
                        height: parent.height
                        model: ["txt", "doc", "Other"]
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
                    if(qtModel.createNewFile(fileNameInput.text, fileType.currentText)){
                        fileNameInput.text = "New File"
                        newFileDialogBox.close()
                    }
                }
            }
            RTextButton{
                text: "Cancel"
                height: 30
                width: 50
                onClicked: newFileDialogBox.reject()
            }
        }
    }

    onOpened: fileNameInput.forceActiveFocus()
}
