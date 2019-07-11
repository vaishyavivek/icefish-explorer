/* $Id: ImageView.qml
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
import QtQuick.Controls 2.12

import "../../CustomComponents"
import "Popups"
import "../../Popups"

Rectangle{
    id: imagePreviewItemRect
    color: rFileSystem.BackgroundColor1

    Column{
        anchors.fill: parent

        Rectangle{
            id: controlBar
            width: parent.width
            height: 50
            color: "transparent"

            RImageButton{
                id: goBackBtn
                icon.source: "/local/assets/back-arrow.svg"
                icon.color: rFileSystem.IconColor1
                hoverText: "Go Back"
                width: parent.height
                height: width
                onClicked: {
                    editingBar.visible = false
                    photoViewerTabView.currentIndex = 0
                }
            }

            Rectangle{
                id: mainControlBar
                width: parent.height*7
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                Row{
                    anchors.fill: parent

                    RImageButton{
                        id: renameBtn
                        icon.source: "/local/assets/rename.svg"
                        hoverText: "Rename"
                        width: parent.height
                        height: width
                    }

                    RImageButton{
                        id: deleteBtn
                        icon.source: "/local/assets/trash.svg"
                        icon.color: rFileSystem.IconColor1
                        hoverText: "Delete"
                        width: parent.height
                        height: width
                    }

                    RImageButton{
                        id: shareBtn
                        icon.source: "/local/assets/share.svg"
                        icon.color: rFileSystem.IconColor1
                        hoverText: "Share with"
                        width: parent.height
                        height: width
                    }

                    RImageButton{
                        id: detailsBtn
                        icon.source: "/local/assets/about.svg"
                        icon.color: rFileSystem.IconColor1
                        hoverText: "See Details"
                        width: parent.height
                        height: width
                        //active: detailsPopup.opened
                        onClicked: {
                            if(!active){
                                rPhotoDetailsModel.FilePath = rPhotoModel.CurrentImagePath
                                detailsPopup.open()
                            }
                            else
                                detailsPopup.close()
                            active = !active
                        }
                    }

                    RImageButton{
                        id: zoomInBtn
                        icon.source: "/local/assets/zoom-in.svg"
                        icon.color: rFileSystem.IconColor1
                        hoverText: "Zoom In"
                        width: parent.height
                        height: width
                        onClicked: {
                            imagePreview.height *= 2
                            imagePreview.width *= 2
                        }
                    }

                    RImageButton{
                        id: zoomOutBtn
                        icon.source: "/local/assets/zoom-out.svg"
                        icon.color: rFileSystem.IconColor1
                        hoverText: "Zoom Out"
                        width: parent.height
                        height: width
                        onClicked: {
                            imagePreview.height *= 0.5
                            imagePreview.width *= 0.5
                        }
                    }

                    RImageButton{
                        id: editImageBtn
                        icon.source: "/local/assets/edit-image.svg"
                        icon.color: rFileSystem.IconColor1
                        hoverText: "Edit with internal tools"
                        width: parent.height
                        height: width
                        onClicked: editingBar.visible = !editingBar.visible

                    }
                }
            }
        }

        Rectangle{
            id: editingBar
            width: controlBar.height*4.5 + 2
            height: controlBar.height*0.75
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            Row{
                anchors.fill: parent
                RImageButton{
                    id: rotateLeftBtn
                    icon.source: "/local/assets/rotate-left.svg"
                    icon.color: rFileSystem.IconColor1
                    hoverText: "Rotate Left"
                    width: parent.height
                    height: width
                    onClicked: rPhotoModel.rotateImage(1)
                }

                RImageButton{
                    id: rotateRightBtn
                    icon.source: "/local/assets/rotate-right.svg"
                    icon.color: rFileSystem.IconColor1
                    hoverText: "Rotate Right"
                    width: parent.height
                    height: width
                    onClicked: rPhotoModel.rotateImage(-1)
                }

                RImageButton{
                    id: cropBtn
                    icon.source: "/local/assets/crop.svg"
                    icon.color: rFileSystem.IconColor1
                    hoverText: "Crop"
                    width: parent.height
                    height: width
                    onClicked: rPhotoModel.rotateImage(-1)
                }

                RImageButton{
                    id: scaleBtn
                    icon.source: "/local/assets/scale.svg"
                    icon.color: rFileSystem.IconColor1
                    hoverText: "Scale"
                    width: parent.height
                    height: width
                    onClicked: rPhotoModel.rotateImage(-1)
                }

                Rectangle{
                    width: 2
                    height: parent.height*0.75
                    color: rFileSystem.HighlightColor
                    opacity: 0.5
                    anchors.verticalCenter: parent.verticalCenter
                }

                RImageButton{
                    id: saveBtn
                    icon.source: "/local/assets/check.svg"
                    icon.color: rFileSystem.IconColor1
                    hoverText: "Save Changes"
                    width: parent.height
                    height: width
                    onClicked: rPhotoModel.saveEditingChangesInCurrentFile()
                }

                RImageButton{
                    id: saveAsBtn
                    icon.source: "/local/assets/save.svg"
                    icon.color: rFileSystem.IconColor1
                    hoverText: "Save Image as..."
                    width: parent.height
                    height: width
                    onClicked: saveAsBox.open()
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 10
            color: "transparent"
        }

        Rectangle{
            id: imageRect
            width: parent.width
            height: parent.height - controlBar.height - editingBar.height
            color: "transparent"
            clip: true

            Flickable{
                id: imageFlick
                width: imageRect.width
                height: imageRect.height
                contentWidth: imagePreview.paintedWidth
                contentHeight: imagePreview.paintedHeight
                contentItem.x: x + width*0.5 - contentWidth*0.5
                contentItem.y: y + height*0.5 - contentHeight*0.5

                Image {
                    id: imagePreview
                    source: "image://preview/" + rFileSystem.PhotoViewProvider.CurrentImagePath
                    sourceSize.height: imageRect.height
                    sourceSize.width: imageRect.width
                    cache: false

                    onSourceChanged: {
                        height = undefined
                        width = undefined
                    }
                }

                onContentXChanged: {
                    if(contentWidth < width)
                        contentItem.x = x + width*0.5 - contentWidth*0.5
                }

                onContentWidthChanged: {
                    if(contentWidth < width)
                        contentItem.x = x + width*0.5 - contentWidth*0.5
                }

                onContentYChanged: {
                    if(contentHeight < height)
                        contentItem.y = y + height*0.5 - contentHeight*0.5
                }

                onContentHeightChanged: {
                    if(contentHeight < height)
                        contentItem.y = y + height*0.5 - contentHeight*0.5
                }
            }
        }
    }


    RImageButton{
        id: previousImageBtn
        icon.source: "/local/assets/move-back.svg"
        icon.color: rFileSystem.IconColor1
        hoverText: "Previous Image"
        width: controlBar.height
        height: width
        enabled: !editingBar.visible
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        onClicked: rPhotoModel.ActiveIndex = rPhotoModel.ActiveIndex - 1
    }

    RImageButton{
        id: nextImageBtn
        icon.source: "/local/assets/move-forward.svg"
        icon.color: rFileSystem.IconColor1
        hoverText: "Next Image"
        width: controlBar.height
        height: width
        enabled: !editingBar.visible
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        onClicked: rPhotoModel.ActiveIndex = rPhotoModel.ActiveIndex + 1
    }

    /*DetailsPopup{
        id: detailsPopup
        x: parent.x + parent.width*0.5 - width*0.5
        y: controlBar.height*1.1
    }

    ScalePopup{
        id: scalePopup
        x: parent.x + parent.width*0.5 - width*0.5
        y: controlBar.height*1.1
    }

    /*FileFolderSelectionDialogBox{
        id: saveAsBox
        onAccepted: rPhotoModel.saveEditingChangesAsNewFile(fileUrl)
    }*/
}
