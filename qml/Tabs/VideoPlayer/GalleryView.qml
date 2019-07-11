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
import QtMultimedia 5.12

Rectangle{
    id: galleryView
    anchors.fill: parent
    color: rFileSystem.BackgroundColor1

    TabView{
        id: photoViewerTabView
        width: parent.width - 20
        height: parent.height - 20
        anchors.centerIn: parent
        //tabsVisible: false
        currentIndex: 0

        Tab{
            ListView{
                id: allPhotosList
                anchors.fill: parent
                anchors.margins: 10
                model: rFileSystem.VideoViewProvider.PQmodel
                clip: true

                delegate: Rectangle{
                    id: allPhotosListDelegate
                    property var metaData: mediaObj.getVideoDetails(model.Path)
                    width: parent.width
                    height: 75
                    color: "transparent"

                    Row{
                        anchors.fill: parent
                        anchors.topMargin: 5
                        anchors.bottomMargin: 5
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 20

                        Image {
                            height: parent.height
                            width: height
                            source: allPhotosListDelegate.metaData.Title
                            sourceSize.height: parent.height*0.85
                            sourceSize.width: parent.height*0.85
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column{
                            width: parent.width - height
                            height: parent.height
                            spacing: 2

                            Text {
                                text: "Title: " + allPhotosListDelegate.metaData.title
                                font.bold: true
                                font.pointSize: 12
                            }
                            Text {
                                text: "Description: " + media.metaData.description
                                font.pointSize: 10
                            }
                            Text {
                                text: "Author: " + media.metaData.author + ", Publisher: " + media.metaData.publisher
                                font.pointSize: 10
                            }
                            Text {
                                text: "Size: " + media.metaData.size
                                font.pointSize: 10
                            }
                        }
                    }



                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
                        onClicked: {
                            rFileSystem.VideoViewProvider.ActiveIndex = index
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
            VideoPlayer{

            }
        }
    }


}
