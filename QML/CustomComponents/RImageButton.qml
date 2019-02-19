import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

Button {
    id: rButton
    property string hoverText: ""
    property bool toolTipEnabled: hoverText.length > 0

    hoverEnabled: true
    padding: 0
    icon.color: "transparent"

    contentItem: Rectangle{
        width: rButton.width
        height: rButton.height
        color: "transparent"
        Image{
            id: image
            source: icon.source
            sourceSize.width: parent.width*0.6
            sourceSize.height: parent.height*0.6
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
        }

        ColorOverlay{
            anchors.fill: image
            source: image
            color: rButton.icon.color
        }
    }

    background: Rectangle {
        id: backgroundRect
        width: rButton.width - 2
        height: rButton.height - 2
        anchors.centerIn: parent
        opacity: enabled ? 1 : 0.4
        color: "transparent"

        Rectangle{
            id: animatingRect
            anchors.fill: parent
            opacity: 0.3
            radius: height/2
            color: "transparent"
        }
    }

    PropertyAnimation{
        id: mouseEnteredAnimation
        target: animatingRect
        property: "color"
        to: rFileSystem.HighlightColor
        duration: rFileSystem.GlobalAnimationDuration
    }

    PropertyAnimation{
        id: mouseExitedAnimation
        target: animatingRect
        property: "color"
        to: "transparent"
        duration: rFileSystem.GlobalAnimationDuration
    }

    ToolTip{
        id: tooltip
        visible: toolTipEnabled && parent.hovered
        text: hoverText
        delay: 500
        timeout: 1000
        contentItem: Text {
            text: tooltip.text
            font: tooltip.font
            color: rFileSystem.BackgroundColor
        }
        background: Rectangle {
            radius: tooltip.height/2
            color: rFileSystem.IconColor
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
