import QtQuick 2.7
import QtQuick.Controls 2.3
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
