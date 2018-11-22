import QtQuick 2.6
import QtQuick.Controls 2.1

Button {
    id: rTextButton
    readonly property string highlightColor: "lightblue"
    //property string te
    property string hoverText: ""
    property bool toolTipEnabled: hoverText.length > 0

    hoverEnabled: true
    padding: 0

    contentItem: Item{
        width: rButton.width
        height: rButton.height
        Rectangle{
            anchors.fill: parent
            opacity: 0.4
            color: "#c4d7dd"
        }

        Text {
            width: parent.width
            height: parent.height
            text: rTextButton.text
            font.family: "Sans Serif"
            clip: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

        }
    }

    background: Rectangle {
        id: backgroundRect
        width: rButton.width - 2
        height: rButton.height - 2
        anchors.centerIn: parent
        opacity: enabled ? 1 : 0.4
        color: "transparent"
    }

    PropertyAnimation{
        id: mouseEnteredAnimation
        target: backgroundRect
        property: "color"
        to: "lightblue"
        duration: 500
    }

    PropertyAnimation{
        id: mouseExitedAnimation
        target: backgroundRect
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

    onHoveredChanged: {
        if(hovered)
            mouseEnteredAnimation.start()
        else if(!checked)
            mouseExitedAnimation.start()
    }

    onCheckedChanged: checked ? mouseEnteredAnimation.start() : mouseExitedAnimation.start()

}
