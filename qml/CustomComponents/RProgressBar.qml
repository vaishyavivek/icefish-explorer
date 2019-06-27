import QtQuick 2.12
import QtQuick.Controls 2.5

ProgressBar {
    id: progress
    width: parent.width
    height: parent.height
    from: 0
    to: 1

    background: Rectangle {
        z: -2
        clip: true
        color: rFileSystem.BackgroundColor2//"transparent"
        implicitWidth: parent.width
        radius: 5
    }

    contentItem: Rectangle {
        z: -2
        clip: true
        color: "transparent"
        opacity: 0.75
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: 5

        Rectangle{
            width: progress.visualPosition * parent.width
            height: parent.height
            radius: 5
            color: rFileSystem.HighlightColor
        }
    }
}
