import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Popup {
    id: sidePanel
    property bool isExpanded: false
    property bool isPined: false
    property int normalizedWidth: 50
    property int widthWhenExpanded: 250

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
                    icon.source: "/local/Resources/icons-menu.svg"
                    icon.color: rFileSystem.IconColor
                    onClicked: (!isPined && isExpanded) ? reverseExpandMenu() : expandMenu()
                }

                RImageButton{
                    id: pinBtn
                    width: normalizedWidth*0.5
                    height: width
                    visible: isExpanded
                    anchors.right: parent.right
                    icon.source: isPined ? "/local/Resources/icons-pin.png" : "/local/Resources/icons-unpin.svg"
                    icon.color: rFileSystem.IconColor
                    onClicked: {
                        if(isPined){
                            isExpanded = false
                            reverseExpandAnimation.start()
                            sideBar.width = normalizedWidth
                        }
                        else
                            sideBar.width = widthWhenExpanded
                        isPined = !isPined
                    }
                }
            }

            Flickable{
                width: parent.width
                height: parent.height
                contentWidth: parent.width
                contentHeight: (rFileSystem.DiskDataListCount + 11)*normalizedWidth

                Column{
                    anchors.fill: parent
                    spacing: 2

                    ButtonGroup{id: radioGroup}

                    RImageExpandingButton{
                        id: homeBar
                        width: parent.width
                        height: normalizedWidth
                        iconPath: "file://" + rDesktopService.getThemeIcon("std-name:user-home", 64)
                        text: "Home"
                        onClicked: updateCurrentDirectory("home")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: documentsBar
                        width: parent.width
                        height: normalizedWidth
                        iconPath: "file://" + rDesktopService.getThemeIcon("std-name:folder-documents", 64)
                        text: "Your Documents"
                        onClicked: updateCurrentDirectory("Documents")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: downloadsBar
                        width: parent.width
                        height: normalizedWidth
                        iconPath: "file://" + rDesktopService.getThemeIcon("std-name:folder-download", 64)
                        text: "Your Downloads"
                        onClicked: updateCurrentDirectory("Downloads")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: musicBar
                        width: parent.width
                        height: normalizedWidth
                        iconPath: "file://" + rDesktopService.getThemeIcon("std-name:folder-music", 64)
                        text: "Your Musics"
                        onClicked: updateCurrentDirectory("Music")
                    }

                    RImageExpandingButton{
                        id: videoBar
                        width: parent.width
                        height: normalizedWidth
                        iconPath: "file://" + rDesktopService.getThemeIcon("std-name:folder-video", 64)
                        text: "Your Videos"
                        onClicked: updateCurrentDirectory("Videos")
                        ButtonGroup.group: radioGroup
                    }

                    RImageExpandingButton{
                        id: pictureBar
                        width: parent.width
                        height: normalizedWidth
                        iconPath: "file://" + rDesktopService.getThemeIcon("std-name:folder-pictures", 64)
                        text: "Your Pictures"
                        onClicked: updateCurrentDirectory("Pictures")
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
                                        color: "lightblue"
                                        implicitWidth: diskListViewDelegate.width
                                    }
                                    progress: Rectangle {
                                        z: -2
                                        clip: true
                                        color: "skyblue"
                                        implicitWidth: diskListViewDelegate.width
                                    }
                                }
                            }
                            RImageExpandingButton{
                                width: parent.width
                                height: normalizedWidth
                                iconPath: "file://" + rDesktopService.getThemeIcon("std-name:drive-harddisk", 64)
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
                        iconPath: "file://" + rDesktopService.getThemeIcon("std-name:folder-favorites", 64)
                        text: "Your Bookmarks"
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
                        iconPath: "file://" + rDesktopService.getThemeIcon("std-name:folder-activities", 64)
                        text: "Your Recently Visited Places"
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
                        iconPath: "file://" + rDesktopService.getThemeIcon("std-name:user-trash", 64)
                        text: "Trash"
                    }

                    RImageExpandingButton{
                        id: settingsBtn
                        width: parent.width
                        height: normalizedWidth
                        iconPath: "/local/Resources/icons-settings.svg"
                        text: "Global Settings"
                        checked: settingsPanel.isOpened

                        SettingsPanel{
                            id: settingsPanel
                            x: sidePanel.width
                            y: sidePanelParentRect.y - settingsBtn.y - 2
                            widthWhenExpanded: mainWindow.width*0.35
                            height: mainWindow.height - 35
                            background: mainWindow.color
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
        duration: 500
    }

    PropertyAnimation{
        id: reverseExpandAnimation
        target: sidePanel
        property: "width"
        to: normalizedWidth
        duration: 500
    }

    Component.onCompleted: sidePanel.open()

    function expandMenu(){
        isExpanded = true
        expandAnimation.start()
    }

    function reverseExpandMenu(){
        isExpanded = false
        reverseExpandAnimation.start()
    }

    function updateCurrentDirectory(Path){
        rFileSystem.updateCurrentDirectoryOnCurrentView(Path, tabHeader.currentIndex)
        if(!isPined)
            reverseExpandMenu()
    }
}
