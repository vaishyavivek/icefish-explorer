import QtQuick 2.7
import QtQuick.Controls 2.4

CheckBox{
    id: check
    readonly property string highlightColor: "lightblue"
    readonly property string selectedColor: "skyblue"
    anchors.verticalCenter: parent.verticalCenter

    indicator: Rectangle {
        id: indicator
        implicitWidth: check.width
        implicitHeight: check.height
        color: "transparent"
        border.color: check.down ? highlightColor : selectedColor

        Rectangle {
            width: parent.width/2
            height: parent.height/2
            radius: 5
            anchors.centerIn: parent
            color: check.down ? highlightColor : selectedColor
            visible: check.checked
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: mouseEnteredAnimation.start()
            onExited: mouseExitedAnimation.start()
            onClicked: check.checked = !check.checked
        }

        PropertyAnimation{
            id: mouseEnteredAnimation
            target: indicator
            property: "color"
            to: highlightColor
            duration: 250
        }
        PropertyAnimation{
            id: mouseExitedAnimation
            target: indicator
            property: "color"
            to: "transparent"
            duration: 250
        }
    }

    contentItem: Item{}
}
