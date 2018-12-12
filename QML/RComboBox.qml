import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

ComboBox {
    id: control
    readonly property string highlightColor: "lightblue"
    readonly property string selectedColor: "skyblue"
    readonly property string borderColor: "blue"

    delegate: ItemDelegate {
        width: control.width
        contentItem: Text {
            anchors.leftMargin: 2
            text: modelData
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        highlighted: control.highlightedIndex === index
    }

    indicator: Rectangle{
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 8
        height: 8

        Image {
            id: image
            source: "/local/assets/icons-move-forward.svg"
            sourceSize.width: parent.width
            sourceSize.height: parent.height
        }
        ColorOverlay{
            anchors.fill: parent
            source: image
            color: highlightColor
        }
    }

    contentItem: Text {
        leftPadding: 2
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: control.pressed ? selectedColor : "black"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: control.width
        implicitHeight: control.height
        border.color: control.pressed ? selectedColor : highlightColor
    }

    popup: Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: highlightColor
        }
    }
}
