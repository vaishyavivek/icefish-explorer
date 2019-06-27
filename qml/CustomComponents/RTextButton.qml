import QtQuick 2.6
import QtQuick.Controls 2.1

Button {
    id: rTextButton
    property string hoverText: ""
    property bool toolTipEnabled: hoverText.length > 0
    property bool alignTextCenter: true
    property int fontSize: 9

    hoverEnabled: true
    padding: 0
    font.pointSize: fontSize
    font.family: "Segoe UI"


    contentItem: Item{
        width: rTextButton.width
        height: rTextButton.height

        Text {
            width: parent.width - 5
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            text: rTextButton.text
            color: rFileSystem.IconColor1
            font: rTextButton.font
            clip: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: alignTextCenter ? Text.AlignHCenter : Text.AlignLeft
        }
    }

    background: Rectangle {
        id: backgroundRect
        width: rTextButton.width - 2
        height: rTextButton.height - 2
        anchors.centerIn: parent
        opacity: enabled ? 1 : 0.5
        radius: 5
        color: "transparent"
    }

    ParallelAnimation{
        id: mouseEnteredAnimation
        PropertyAnimation{
            target: rTextButton
            property: "font.pointSize"
            to: fontSize + 2
            duration: rFileSystem.GlobalAnimationDuration
        }

        /*PropertyAnimation{
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
        }*/
    }


    ParallelAnimation{
        id: mouseExitedAnimation
        PropertyAnimation{
            target: rTextButton
            property: "font.pointSize"
            to: fontSize
            duration: rFileSystem.GlobalAnimationDuration
        }
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
            target: rTextButton
            property: "font.pointSize"
            to: fontSize
            duration: rFileSystem.GlobalAnimationDuration
        }
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
