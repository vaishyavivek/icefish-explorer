/* $Id: GalleryView.qml
 * IceFish Explorer is a free File Manager for Linux Desktops for managing
 * local files as well as files on cloud, Dropbox, Onedrive, Googledrive.
 * Additionally, it also serves as a multimedia explorer for your photos,
 * music, videos, documents and other files by providing built-in plugins
 * to open them.
 * © IceFish Community, 2019
 *
 * This file is part of IceFish Explorer.
 *
 * IceFish Explorer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * IceFish Explorer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with IceFish Explorer.
 * If not, see <http://www.gnu.org/licenses/>.
 *
 * The project is hosted here,
 * http://www.icefish.tech/index/explorer/0-5
*/

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
