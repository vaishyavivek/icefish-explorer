import QtQuick 2.6
import QtQuick.Controls 2.1
//import QtGraphicalEffects 1.0

Button {
    id: rButton
    property string iconPath
    readonly property string highlightColor: "lightblue"
    property string hoverText: ""
    property bool toolTipEnabled: hoverText.length > 0

    hoverEnabled: true
    padding: 0


    /*contentItem: Rectangle{
        width: rButton.width
        height: rButton.height
        color: "transparent"
        Image{
            id: image
            source: rButton.iconPath
            sourceSize.width: parent.width*0.75
            sourceSize.height: parent.height*0.75
            anchors.centerIn: parent
        }

        ColorOverlay{
            anchors.fill: image
            source: rButton.iconPath
            color: mainWindow.fontColor
        }
    }*/

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
