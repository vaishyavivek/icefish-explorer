import QtQuick 2.6
import QtQuick.Controls 2.1

Button {
    id: rTextButton
    property string hoverText: ""
    property bool toolTipEnabled: hoverText.length > 0

    hoverEnabled: true
    padding: 0

    contentItem: Item{
        width: rTextButton.width
        height: rTextButton.height
        Rectangle{
            anchors.fill: parent
            opacity: 0.8
            color: rFileSystem.BackgroundColor
            radius: 5
        }

        Text {
            width: parent.width
            height: parent.height
            text: rTextButton.text
            color: rFileSystem.IconColor
            font.family: "Sans Serif"
            clip: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

        }
    }

    background: Rectangle {
        id: backgroundRect
        width: rTextButton.width - 2
        height: rTextButton.height - 2
        anchors.centerIn: parent
        opacity: enabled ? 1 : 0.4
        color: "transparent"
        Rectangle{
            id: animatingRect
            anchors.fill: parent
            opacity: (color === "transparent" ? 0.3 : 0.6)
            radius: 5
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
        delay: 200
        timeout: 1000
        contentItem: Text {
            text: tooltip.text
            font: tooltip.font
            color: rFileSystem.BackgroundColor
        }
        background: Rectangle {
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