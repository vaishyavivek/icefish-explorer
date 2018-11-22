import QtQuick 2.7
import QtQuick.Controls 2.3

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

    footer: DialogButtonBox{
        padding: 0
        height: 40
        alignment: Qt.AlignHCenter
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
             DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
             height: 30
             width: 50
         }
    }

    onOpened: fileNameInput.forceActiveFocus()
}
