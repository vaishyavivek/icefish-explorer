import QtQuick 2.12
import QtQuick.Controls 2.12

Slider {
    id: control
    property string hoverText: ""
    property bool toolTipEnabled: hoverText.length > 0

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: "transparent"

        Rectangle{
            width: parent.width
            height: parent.height
            color: rFileSystem.BackgroundColor2
            radius: 2
            opacity: 0.25
        }

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: rFileSystem.SelectedColor
            radius: 2
            opacity: 0.75
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: parent.height*0.75
        implicitHeight: implicitWidth
        radius: implicitWidth
        color: control.pressed ? rFileSystem.SelectedColor : rFileSystem.BackgroundColor1
        opacity: 0.75
        border.color: rFileSystem.BackgroundColor2
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
}
