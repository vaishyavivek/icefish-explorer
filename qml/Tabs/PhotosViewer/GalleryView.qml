import QtQuick 2.12
import QtQuick.Controls 1.4

Rectangle{
    id: galleryView
    anchors.fill: parent
    color: rFileSystem.BackgroundColor1

    TabView{
        id: photoViewerTabView
        width: parent.width - 20
        height: parent.height - 20
        anchors.centerIn: parent
        tabsVisible: false
        currentIndex: 0

        Tab{
            GridView{
                id: allPhotosList
                anchors.fill: parent
                anchors.margins: 10
                model: rFileSystem.PhotoViewProvider.PQmodel
                clip: true
                cellWidth: 110
                cellHeight: cellWidth

                delegate: Rectangle{
                    id: allPhotosListDelegate
                    width: 100
                    height: 100
                    color: "transparent"

                    Image {
                        source: "file://" + model.Path
                        sourceSize.height: parent.height*0.85
                        sourceSize.width: parent.width*0.85
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
                        onClicked: {
                            rFileSystem.PhotoViewProvider.ActiveIndex = index
                            photoViewerTabView.currentIndex = 1
                        }
                    }

                    Rectangle{
                        id: animatingRect
                        anchors.fill: parent
                        radius: 5
                        opacity: 0.25
                        color: "transparent"
                    }


                    PropertyAnimation{
                        id: mouseEnteredAnimation
                        target: animatingRect
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: rFileSystem.HighlightColor
                        duration: rFileSystem.GlobalAnimationDuration
                    }
                    PropertyAnimation{
                        id: mouseExitedAnimation
                        target: animatingRect
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: "transparent"
                        duration: rFileSystem.GlobalAnimationDuration
                    }
                }
            }
        }

        Tab{
            ImageView{
            }
        }
    }


}
