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
            sourceSize.width: parent.width*0.5
            sourceSize.height: parent.height*0.5
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
        opacity: enabled ? 1 : 0.5
        radius: 5
    }

    ParallelAnimation{
        id: mouseEnteredAnimation
        PropertyAnimation{
            target: backgroundRect
            property: "color"
            to: rFileSystem.HighlightColor
            duration: rFileSystem.GlobalAnimationDuration
        }
        PropertyAnimation{
            target: backgroundRect
            property: "opacity"
            to: 0.5
            duration: rFileSystem.GlobalAnimationDuration
        }
    }


    ParallelAnimation{
        id: mouseExitedAnimation
        PropertyAnimation{
            target: backgroundRect
            property: "color"
            to: "transparent"
            duration: rFileSystem.GlobalAnimationDuration
        }
        PropertyAnimation{
            target: backgroundRect
            property: "opacity"
            to: 1
            duration: rFileSystem.GlobalAnimationDuration
        }
    }


    PropertyAnimation{
        id: checkedAnimation
        target: backgroundRect
        property: "color"
        to: rFileSystem.SelectedColor
        duration: rFileSystem.GlobalAnimationDuration
    }


    ParallelAnimation{
        id: mouseExitedAnimationOnChecked
        PropertyAnimation{
            target: backgroundRect
            property: "color"
            to: rFileSystem.SelectedColor
            duration: rFileSystem.GlobalAnimationDuration
        }
        PropertyAnimation{
            target: backgroundRect
            property: "opacity"
            to: 1
            duration: rFileSystem.GlobalAnimationDuration
        }
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
            color: rFileSystem.IconColor2
        }
        background: Rectangle {
            radius: 5
            color: rFileSystem.BackgroundColor2
            opacity: 0.75
        }
    }

    onHoveredChanged: {
        if(hovered)
            mouseEnteredAnimation.start()
        else if(!checked)
            mouseExitedAnimation.start()
        else
            mouseExitedAnimationOnChecked.start()
    }

    onCheckedChanged: checked ? checkedAnimation.start() : mouseExitedAnimation.start()

}
