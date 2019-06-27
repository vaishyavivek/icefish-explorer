import QtQuick 2.6
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Popup{
    id: scalePopup
    width: 400
    height: 250
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle{
        color: rFileSystem.BackgroundColor
        opacity: 0.8
        border.width: 1
        border.color: rFileSystem.SelectedColor

        DropShadow{
            anchors.fill: parent
            source: parent
            horizontalOffset: 2
            verticalOffset: 2
            radius: 2
            samples: 5
            color: "#80000000"
        }
    }

    contentItem: Column{
        anchors.fill: parent
        anchors.margins: 5
        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"
            Text {
                id: originalDimensions
                width: parent.width
                height: parent.height
                text: qsTr("<b>Original Dimensions: </b>" + rPhotoDetailsModel.ImageDimensions)
                font.pointSize: 11
                font.weight: Font.Thin
                color: rFileSystem.IconColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"
            Row{
                anchors.fill: parent
                Text {
                    id: changeByPercent
                    height: parent.height
                    text: qsTr("<b>Scale by Percent: </b>" )
                    font.pointSize: 11
                    font.weight: Font.Thin
                    color: rFileSystem.IconColor
                }
            }
        }
    }
}
