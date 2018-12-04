import QtQuick 2.8
import QtQuick.Controls 2.4

SpinBox {
    id: scaleControl
    property string hoverText: ""
    property bool toolTipEnabled: hoverText.length > 0

    from: 0
    to: items.length - 1
    value: 1
    hoverEnabled: true
    padding: 2
    background: rFileSystem.BackgroundColor

    property var items: ["Tiny", "Small", "Medium", "Big", "Large"]
    property var itemsInt: [16, 32, 48, 64, 80]

    validator: RegExpValidator {
        regExp: new RegExp("(Tiny|Small|Optimum|Big|Large)", "i")
    }

    textFromValue: function(value) {
        return items[value];
    }

    valueFromText: function(text) {
        for (var i = 0; i < items.length; ++i) {
            if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                return i
        }
        return sb.value
    }

    property var getValue: function(){
        return itemsInt[value]
    }

    property var setValue: function(newValue){
        return itemsInt.indexOf(newValue)
    }

    contentItem: Text{
        color: rFileSystem.IconColor
        text: scaleControl.textFromValue(scaleControl.value, scaleControl.locale)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }


    up.indicator: Rectangle {
        x: scaleControl.mirrored ? 0 : parent.width - width
        height: parent.height
        implicitWidth: scaleControl.width/3 - 5
        implicitHeight: scaleControl.height
        color: scaleControl.up.pressed ? "lightblue" : "transparent"
        border.color: enabled ? rFileSystem.IconColor : "black"
        Text {
            text: "+"
            font.pointSize: scaleControl.height*0.75
            color: scaleControl.up.pressed ? "skyblue" : rFileSystem.IconColor
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    down.indicator: Rectangle {
        x: scaleControl.mirrored ? parent.width - width : 0
        height: parent.height
        implicitWidth: scaleControl.width/3 - 5
        implicitHeight: scaleControl.height
        color: scaleControl.down.pressed ? "lightblue" : "transparent"
        border.color: enabled ? rFileSystem.IconColor : "black"
        Text {
            text: "-"
            font.pointSize: scaleControl.height*0.75
            color: scaleControl.down.pressed ? "skyblue" : rFileSystem.IconColor
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    ToolTip{
        id: tooltip
        visible: toolTipEnabled && scaleControl.hovered
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
}
