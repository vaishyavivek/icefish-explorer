import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
//import Qt.labs.platform 1.0
import "../CustomComponents"

Popup {
    id: sidePanel
    property bool isExpanded: false
    property bool isPined: rFileSystem.IsPinPinned
    property int normalizedWidth: 35
    property int widthWhenExpanded: 200

    padding: 0
    rightPadding: 1
    width: parent.width
    height: parent.height
    closePolicy: Popup.NoAutoClose

    Rectangle{
        id: sidePanelParentRect
        width: parent.width
        height: parent.height
        color: rFileSystem.BackgroundColor

        Rectangle{
            anchors.fill: parent
            opacity: 0.2
            color: rFileSystem.HighlightColor
        }

        Column{
            anchors.fill: parent
            spacing: 2
            Rectangle{
                id: controlBar
                width: parent.width
                height: normalizedWidth //OR iconScale
                color: "transparent"

                RImageButton{
                    id: hamburgerBtn
                    width: normalizedWidth
                    height: normalizedWidth
                    icon.source: "/local/assets/menu.svg"
                    icon.color: rFileSystem.IconColor
                    onClicked: (!isPined && isExpanded) ? reverseExpandMenu() : expandMenu()
                }

                RImageButton{
                    id: pinBtn
                    width: normalizedWidth*0.5
                    height: width
                    visible: isExpanded
                    anchors.right: parent.right
                    icon.source: isPined ? "/local/assets/pin.png" : "/local/assets/unpin.svg"
                    icon.color: rFileSystem.IconColor
                    onClicked: rFileSystem.IsPinPinned = !isPined
                }
            }

            Flickable{
                width: parent.width
                height: parent.height
                contentWidth: parent.width
                contentHeight: (rFileSystem.DiskDataListCount + 14)*normalizedWidth

                Column{
                    anchors.fill: parent
                    spacing: 2

                    ButtonGroup{id: radioGroup}

                    RImageExpandingButton{
                        id: homeBar
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "image://xdg/user-home"
                        text: "Home"
                        onClicked: updateCurrentDirectory("home")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: documentsBar
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "image://xdg/folder-documents"
                        text: "Documents"
                        onClicked: updateCurrentDirectory("Documents")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: downloadsBar
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "image://xdg/folder-downloads"
                        text: "Downloads"
                        onClicked: updateCurrentDirectory("Downloads")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: musicBar
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "image://xdg/folder-music"
                        text: "Musics"
                        onClicked: updateCurrentDirectory("Music")
                    }

                    RImageExpandingButton{
                        id: videoBar
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "image://xdg/folder-video"
                        text: "Videos"
                        onClicked: updateCurrentDirectory("Videos")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: pictureBar
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "image://xdg/folder-pictures"
                        text: "Pictures"
                        onClicked: updateCurrentDirectory("Pictures")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: dropboxBtn
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "image://xdg/dropbox"
                        text: "Dropbox"
                        onClicked: rFileSystem.createNewTab("cloud://dropbox")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: onedriveBtn
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "/local/assets/onedrive.svg"
                        text: "OneDrive"
                        onClicked: rFileSystem.createNewTab("cloud://onedrive")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: gdriveBtn
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "/local/assets/google-drive.svg"
                        text: "Google Drive"
                        onClicked: rFileSystem.createNewTab("cloud://gdrive")
                        ButtonGroup.group: radioGroup
                    }

                    Rectangle{
                        height: 2
                        width: parent.width
                        color: "grey"
                        opacity: 0.5
                        clip: true
                    }

                    ListView{
                        id: diskListView
                        width: parent.width
                        height: count*normalizedWidth
                        spacing: 2
                        clip: true
                        model: rFileSystem.DiskDataList

                        delegate: Rectangle{
                            id: diskListViewDelegate
                            width: parent.width
                            height: normalizedWidth
                            color: "transparent"

                            ProgressBar {
                                id: progress
                                opacity: 0.4
                                width: parent.width - 2
                                height: parent.height
                                visible: (width - height > 1)
                                value: 1 - model.modelData.UsedVolumeSize/model.modelData.TotalVolumeSize
                                minimumValue: 0
                                maximumValue: 1
                                style: ProgressBarStyle {
                                    background: Rectangle {
                                        z: -2
                                        clip: true
                                        color: rFileSystem.HighlightColor
                                        implicitWidth: diskListViewDelegate.width
                                    }
                                    progress: Rectangle {
                                        z: -2
                                        clip: true
                                        color: rFileSystem.IconColor
                                        implicitWidth: diskListViewDelegate.width
                                    }
                                }
                            }
                            RImageExpandingButton{
                                width: parent.width
                                height: normalizedWidth
                                icon.source: "image://xdg/drive-harddisk"
                                text: "<b>" + model.modelData.DisplayName + "</b> (" + model.modelData.DevName + ")"
                                onClicked: {
                                    updateCurrentDirectory(model.modelData.MountPoint)
                                    mainTabControl.forceActiveFocus()
                                }
                                ButtonGroup.group: radioGroup
                            }
                        }
                    }

                    Rectangle{
                        height: 2
                        width: parent.width
                        color: "grey"
                        opacity: 0.5
                        clip: true
                    }

                    RImageExpandingButton{
                        id: bookmarksBtn
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "image://xdg/folder-favorites"
                        text: "Bookmarks"
                        hoverText: "Your Bookmarks"
                        checked: bookmarkPanel.isOpened

                        BookmarkPanel{
                            id: bookmarkPanel
                            x: sidePanel.width
                            y: sidePanelParentRect.y - bookmarksBtn.y - 2
                            widthWhenExpanded: mainWindow.width*0.35
                            height: mainWindow.height - 35
                        }
                        onClicked: {
                            bookmarkPanel.isOpened ? bookmarkPanel.close() : bookmarkPanel.open()
                            bookmarkPanel.isOpened = !bookmarkPanel.isOpened
                        }
                    }
                    RImageExpandingButton{
                        id: recentsBtn
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "image://xdg/folder-activities"
                        text: "Recents"
                        hoverText: "Your Recently Visited Places"
                        checked: recentsPanel.isOpened

                        RecentsPanel{
                            id: recentsPanel
                            x: sidePanel.width
                            y: sidePanelParentRect.y - recentsBtn.y - 2
                            widthWhenExpanded: mainWindow.width*0.35
                            height: mainWindow.height - 35
                        }
                        onClicked: {
                            recentsPanel.isOpened ? recentsPanel.close() : recentsPanel.open()
                            recentsPanel.isOpened = !recentsPanel.isOpened
                        }
                    }
                    RImageExpandingButton{
                        id: trashBtn
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "image://xdg/user-trash"
                        text: "Trash"
                        checked: trashPanel.isOpened

                        TrashPanel{
                            id: trashPanel
                            x: sidePanel.width
                            y: sidePanelParentRect.y - trashBtn.y - 2
                            widthWhenExpanded: mainWindow.width*0.35
                            height: mainWindow.height - 35
                        }

                        onClicked: {
                            trashPanel.isOpened ? trashPanel.close() : trashPanel.open()
                            trashPanel.isOpened = !trashPanel.isOpened
                        }
                    }

                    Rectangle{
                        height: 2
                        width: parent.width
                        color: "grey"
                        opacity: 0.5
                        clip: true
                    }

                    RImageExpandingButton{
                        id: processBtn
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "/local/assets/process.svg"
                        icon.color: rFileSystem.IconColor
                        text: "Processes"
                        hoverText: "File Operations you perform"
                        checked: indicatorPanel.isOpened

                        IndicatorPanel{
                            id: indicatorPanel
                            x: sidePanel.width
                            y: sidePanelParentRect.y - processBtn.y - 2
                            widthWhenExpanded: mainWindow.width*0.35
                            height: mainWindow.height - 35
                        }
                        onClicked: {
                            indicatorPanel.isOpened ? indicatorPanel.close() : indicatorPanel.open()
                            indicatorPanel.isOpened = !indicatorPanel.isOpened
                        }
                    }

                    RImageExpandingButton{
                        id: settingsBtn
                        width: parent.width
                        height: normalizedWidth
                        icon.source: "/local/assets/settings.svg"
                        icon.color: rFileSystem.IconColor
                        text: "Global Settings"
                        hoverText: "Customize your File Manager"
                        checked: settingsPanel.isOpened

                        SettingsPanel{
                            id: settingsPanel
                            x: sidePanel.width
                            y: sidePanelParentRect.y - settingsBtn.y - 2
                            widthWhenExpanded: mainWindow.width*0.35
                            height: mainWindow.height - 35
                        }
                        onClicked: {
                            settingsPanel.isOpened ? settingsPanel.close() : settingsPanel.open()
                            settingsPanel.isOpened = !settingsPanel.isOpened
                        }
                    }

                }
            }
        }
    }

    PropertyAnimation{
        id: expandAnimation
        target: sidePanel
        property: "width"
        to: widthWhenExpanded
        duration: rFileSystem.GlobalAnimationDuration*2
    }

    PropertyAnimation{
        id: reverseExpandAnimation
        target: sidePanel
        property: "width"
        to: normalizedWidth
        duration: rFileSystem.GlobalAnimationDuration*2
    }

    Component.onCompleted: sidePanel.open()

    function expandMenu(){
        if(!isExpanded){
            isExpanded = true
            expandAnimation.start()
        }
        if(isPined)
            sideBar.width = widthWhenExpanded
    }

    function reverseExpandMenu(){
        if(isExpanded){
            isExpanded = false
            reverseExpandAnimation.start()
            sideBar.width = normalizedWidth
        }
    }

    function updateCurrentDirectory(Path){
        rFileSystem.updateCurrentDirectoryOnCurrentView(Path, tabHeader.currentIndex)
        if(!isPined)
            reverseExpandMenu()
    }

    onIsPinedChanged: {
        widthWhenExpanded = 200
        isPined ? expandMenu() : reverseExpandMenu()
    }
}
