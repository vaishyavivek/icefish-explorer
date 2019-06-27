import QtQuick 2.6
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Popup{
    id: detailsPopup
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
                id: name
                width: parent.width
                height: parent.height
                text: qsTr("<b>Name: </b>" + rPhotoDetailsModel.FileName)
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
            Text {
                id: dimensions
                width: parent.width
                height: parent.height
                text: qsTr("<b>Image Dimensions: </b>" + rPhotoDetailsModel.ImageDimensions)
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
            Text {
                id: lastModified
                width: parent.width
                height: parent.height
                text: qsTr("<b>Time Modified: </b>" + rPhotoDetailsModel.TimeModified)
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
            Text {
                id: fileSize
                width: parent.width
                height: parent.height
                text: qsTr("<b>FileSize: </b>" + rPhotoDetailsModel.FileSize)
                font.pointSize: 11
                font.weight: Font.Thin
                color: rFileSystem.IconColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    enter: Transition{
        NumberAnimation{
            property: "opacity"
            duration: rFileSystem.GlobalAnimationDuration
            from: 0
            to: 0.8
        }
    }

    exit: Transition{
        NumberAnimation{
            property: "opacity"
            duration: rFileSystem.GlobalAnimationDuration
            to: 0
        }
    }

}
