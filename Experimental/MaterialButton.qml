import QtQuick 2.7
import QtQuick.Controls 2.2

Rectangle{
    id: materialButton
    readonly property string highlightColor: "lightblue"
    readonly property string selectedColor: "skyblue"
    property string iconPath: ""
    property string hoverText: ""
    property bool isActive: true
    property bool toolTipEnabled: hoverText.length > 0
    property bool hovered: false

    signal clicked

    color: "transparent"

    Image {
        id: hamburgerIcon
        source: iconPath
        sourceSize.width: parent.width*0.75
        sourceSize.height: parent.height*0.75
        anchors.centerIn: parent
    }
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            hovered = true
            if(isActive)
                mouseEnteredAnimation.start()
        }
        onExited: {
            hovered = false
            mouseExitedAnimation.start()
        }
        onClicked: {
            if(isActive)
                materialButton.clicked()
        }
    }

    PropertyAnimation{
        id: mouseEnteredAnimation
        target: materialButton
        property: "color"
        to: highlightColor
        duration: 500
    }
    PropertyAnimation{
        id: mouseExitedAnimation
        target: materialButton
        property: "color"
        to: "transparent"
        duration: 500
    }

    ToolTip{
        id: tooltip
        visible: toolTipEnabled && parent.hovered
        text: hoverText
        delay: 200
        timeout: 1000
        contentItem: Text {
            text: tooltip.text
            font: tooltip.font
            color: "white"
        }
        background: Rectangle {
            color: "black"
        }
    }
}
