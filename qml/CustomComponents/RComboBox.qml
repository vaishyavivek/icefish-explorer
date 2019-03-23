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
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 8
        height: 8

        Image {
            id: image
            source: "/local/assets/move-forward.svg"
            sourceSize.width: parent.width
            sourceSize.height: parent.height
        }
        ColorOverlay{
            anchors.fill: parent
            source: image
            color: rFileSystem.HighlightColor
        }
    }

    contentItem: Text {
        leftPadding: 2
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: control.pressed ? rFileSystem.SelectedColor : rFileSystem.IconColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        color: rFileSystem.HighlightColor
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
