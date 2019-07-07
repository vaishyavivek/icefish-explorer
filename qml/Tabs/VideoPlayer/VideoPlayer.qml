import QtQuick 2.12
import QtQuick.Controls 1.4
import QtMultimedia 5.12

Rectangle{
    id: imagePreviewItemRect
    color: "black"

    MediaPlayer{
        id: media
        source: "file://" + rFileSystem.VideoViewProvider.CurrentVideoPath
        autoPlay: true
    }

    VideoOutput{
        anchors.fill: parent
        source: media
    }
}
