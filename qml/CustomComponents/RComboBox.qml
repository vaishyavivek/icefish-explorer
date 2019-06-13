import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

ComboBox {
    id: control

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
        x: control.width - height
        width: height
        height: control.height
        color: "transparent"

        Image {
            id: image
            source: "/local/assets/combobox-arrow.svg"
            sourceSize.width: parent.width*0.5
            sourceSize.height: parent.height*0.5
            anchors.centerIn: parent
        }
        ColorOverlay{
            anchors.fill: image
            source: image
            color: rFileSystem.HighlightColor
        }
    }

    contentItem: Text {
        leftPadding: control.height*0.25
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: control.pressed ? rFileSystem.SelectedColor : rFileSystem.IconColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        color: rFileSystem.HighlightColor
        opacity: 0.25
        implicitWidth: control.width
        implicitHeight: control.height
        border.color: control.pressed ? rFileSystem.SelectedColor : rFileSystem.HighlightColor
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
            border.color: rFileSystem.IconColor
        }
    }
}
