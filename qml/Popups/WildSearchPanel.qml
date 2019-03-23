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
