import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

Button {
    id: rButton
    property string hoverText: "Your " + text + " Folder"
    property bool toolTipEnabled: hoverText.length > 0

    checkable: true
    hoverEnabled: true
    padding: 0
    icon.color: rFileSystem.IconColor

    contentItem: Rectangle{
        width: rButton.width
        height: rButton.height
        color: "transparent"

        Row{
            anchors.fill: parent
            spacing: 5
            Rectangle{
                id: imageRect
                height: parent.height
                width: height*0.9
                color: "transparent"
                Image {
                    id: image
                    source: icon.source
                    visible: false
                    sourceSize.width: parent.height*0.6
                    sourceSize.height: parent.height*0.6
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                }
                ColorOverlay{
                    anchors.fill: image
                    source: image
                    color: icon.color
                }
            }

            Rectangle{
                width: parent.width - imageRect.width
                height: parent.height
                color: "transparent"
                Text {
                    color: rFileSystem.IconColor
                    text: rButton.text
                    font: rButton.font
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width
                    height: parent.height
                    clip: true
                }
            }
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
        delay: 200
        timeout: 1000
        contentItem: Text {
            text: tooltip.text
            font: tooltip.font
            color: rFileSystem.BackgroundColor
        }
        background: Rectangle {
            radius: height/2
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
