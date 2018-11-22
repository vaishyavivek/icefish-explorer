import QtQml 2.1
import QtQuick 2.8
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Rectangle{
    id: tabViewDelegate
    property int scaleFactor: qtModel.IconScale
    property var qtModel
    property int lastIndexPositions: []

    width: parent.width
    height: parent.height
    color: mainWindow.color

    Column{
        anchors.fill: parent
        spacing: 5
        Row{
            width: parent.width
            height: 35
            RImageButton{
                id: backBtn
                height: parent.height
                width: height
                iconPath: "/local/Resources/icons-move-back.svg"
                hoverText: "Move Backward"
                enabled: false
                onClicked: qtModel.navigateBackward()
                Connections{
                    target: qtModel
                    ignoreUnknownSignals: true
                    onBackNavBtnEnabled: backBtn.enabled = newValue
                }
            }

            RImageButton{
                id: forwardBtn
                height: parent.height
                width: height
                iconPath: "/local/Resources/icons-move-forward.svg"
                hoverText: "Move Forward"
                enabled: false
                onClicked: qtModel.navigateForward()
                Connections{
                    target: qtModel
                    ignoreUnknownSignals: true
                    onForNavBtnEnabled: forwardBtn.enabled = newValue
                }
            }

            RImageButton{
                id: reloadBtn
                height: parent.height
                width: height
                iconPath: "/local/Resources/icons-reload.svg"
                hoverText: "Reload"
                onClicked: qtModel.reloadCurrentDirectory()
                Connections{
                    target: qtModel
                    ignoreUnknownSignals: true
                    onReloadBtnEnabled: reloadBtn.enabled = newValue
                }
            }

            AddressBox{
                id: addressBox
                width: parent.width - parent.height*3
                height: parent.height
            }
        }

        Rectangle{
            width: parent.width
            height: 1
            opacity: 0.2
            color: "black"
        }

        Rectangle{
            id: fileFolderListViewHeaderRect
            width: parent.width
            height: 35
            color: "transparent"

            Row{
                id: defaultLayout
                opacity: 1
                height: parent.height
                width: height*5

                Rectangle{
                    width: 7
                    height: parent.height
                    color: "transparent"
                }

                RCheckBox{
                    id: selectAll
                    height: parent.height*0.75
                    width: height
                    //onCheckedChanged:
                }

                Rectangle{
                    width: 10
                    height: parent.height
                    color: "transparent"
                }

                RImageButton{
                    id: newFileBtn
                    height: parent.height
                    width: height
                    iconPath: "file://" + rDesktopService.getThemeIcon("std-name:x-office-document", 64)
                    hoverText: "New File"
                    Image {
                        z: 2
                        source: "/local/Resources/icons-add.svg"
                        sourceSize.width: parent.width*0.4
                        sourceSize.height: parent.height*0.4
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 2
                    }
                    onClicked: newFileDialogBox.open()

                    NewFileDialogBox{
                        id: newFileDialogBox
                        title: "New File"
                        currentPath: qtModel.AddressBoxData
                        width: 250
                        height: 155
                        //background: tabViewDelegate.color
                    }
                }

                RImageButton{
                    id: newFolderBtn
                    height: parent.height
                    width: height
                    iconPath: "file://" + rDesktopService.getThemeIcon("std-name:folder", 64)
                    hoverText: "New Folder"
                    Image {
                        z: 2
                        source: "/local/Resources/icons-add.svg"
                        sourceSize.width: parent.width*0.4
                        sourceSize.height: parent.height*0.4
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 2
                    }
                    onClicked: newFolderDialogBox.open()

                    NewFolderDialogBox{
                        id: newFolderDialogBox
                        title: "New Folder"
                        currentPath: qtModel.AddressBoxData
                        width: 250
                        height: 155
                        //background: tabViewDelegate.color
                    }
                }
            }

            Row{
                id: layoutWhenSelected
                opacity: 0
                height: parent.height
                width: height*6
                anchors.leftMargin: 5
            }


            Row{
                id: globalControls
                height: parent.height
                width: height*6.5 + 7
                anchors.right: parent.right

                RImageButton{
                    id: favoriteBtn
                    property bool isBookmarked: qtModel.IsBookmarked
                    height: parent.height
                    width: height
                    iconPath: "file://" + rDesktopService.getThemeIcon("std-name:folder-bookmark", 64)
                    hoverText: "Bookmark this place"
                    onClicked: qtModel.IsBookmarked = !isBookmarked

                    Image {
                        id: bookmarkIndicator
                        z: 2
                        visible: favoriteBtn.isBookmarked
                        source: "/local/Resources/icons-check.svg"
                        sourceSize.width: parent.width*0.5
                        sourceSize.height: parent.height*0.5
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 2
                    }
                }

                RImageButton{
                    id: showHiddenBtn
                    property bool nowVisible: qtModel.IsHiddenItemsShown
                    height: parent.height
                    width: height
                    iconPath: "file://" + rDesktopService.getThemeIcon("std-name:folder", 64)
                    hoverText: (nowVisible ? "Hide Hidden Items" : "Show Hidden Items")
                    onClicked: qtModel.IsHiddenItemsShown = !nowVisible

                    Image {
                        id: visibleIndicator
                        z: 2
                        visible: showHiddenBtn.nowVisible
                        source: "/local/Resources/icons-preview.svg"
                        sourceSize.width: parent.width*0.5
                        sourceSize.height: parent.height*0.5
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 2
                    }
                }

                RImageButton{
                    id: imagePreviewBtn
                    property bool nowPreviewing: qtModel.IsPreviewAvailable
                    height: parent.height
                    width: height
                    iconPath: "file://" + rDesktopService.getThemeIcon("std-name:image-x-generic", 64)
                    hoverText: (nowPreviewing ? "Stop Previewing items" : "Enable Image Preview")
                    onClicked: qtModel.IsPreviewAvailable = !nowPreviewing

                    Image {
                        id: previewIndicator
                        z: 2
                        visible: imagePreviewBtn.nowPreviewing
                        source: "/local/Resources/icons-preview.svg"
                        sourceSize.width: parent.width*0.5
                        sourceSize.height: parent.height*0.5
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 2
                    }
                }

                RScaleControlSpinBox{
                    id: scaleControl
                    height: parent.height*0.75
                    width: parent.height*3.5
                    anchors.verticalCenter: parent.verticalCenter
                    hoverText: "Icon Scale"
                    onValueModified: qtModel.IconScale = getValue()
                    background: tabViewDelegate.color
                    value: setValue(scaleFactor)
                }

                Rectangle{
                    width: 7
                    height: parent.height
                    color: "transparent"
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 1
            opacity: 0.2
            color: "black"
        }

        Rectangle{
            id: fileFolderListViewParentRect
            width: parent.width
            height: parent.height - 82
            color: "transparent"
            ListView{
                id: fileFolderListView
                property bool editing: false
                property int returnToIndex: []
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                clip: true
                keyNavigationEnabled: true
                model: qtModel.FileFolderList

                delegate: Rectangle{
                    id: fileFolderListviewDelegate
                    property variant filePath: model.modelData.Path
                    property variant menuModel: model.modelData.ActionsMenu
                    width: parent.width
                    height: scaleFactor
                    color: "transparent"

                    Row{
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 10

                        RCheckBox{
                            id: check
                            height: parent.height*0.5
                            width: height
                            onCheckedChanged: model.modelData.Checked = checked
                        }

                        Rectangle{
                            id: icon
                            height: parent.height*0.9
                            width: scaleFactor
                            color: "transparent"
                            Image {
                                id: iconImage
                                anchors.centerIn: parent
                                source: model.modelData.IsPreviewAvailable ? model.modelData.PreviewPath : model.modelData.IconPath
                                sourceSize.width: parent.width*0.9
                                sourceSize.height: parent.height*0.9
                                //cache: false
                                //asynchronous: true
                            }
                            ColorOverlay{
                                anchors.fill: iconImage
                                source: iconImage
                                color: model.modelData.IsHidden ? "#81abc7" : "transparent"
                            }

                            Connections{
                                target: imagePreviewBtn
                                ignoreUnknownSignals: true
                                onNowPreviewingChanged: model.modelData.IsPreviewAvailable = imagePreviewBtn.nowPreviewing
                            }
                        }

                        Rectangle{
                            id: displayName
                            width: (parent.width - check.width - icon.width)*0.5
                            height: parent.height
                            color: "transparent"
                            TextInput {
                                id: nameInput
                                text: model.modelData.DisplayName
                                font.family: "Sans Serif"
                                color: mainWindow.fontColor
                                font.pointSize: Math.max(scaleFactor*0.16, 8)
                                anchors.verticalCenter: parent.verticalCenter
                                clip: true

                                readOnly: true
                                validator: RegExpValidator{regExp: /^[-\w^&'@{}[\],$=!#().%+~ ]+$/}
                                onAccepted: {
                                    model.modelData.DisplayName = text
                                    readOnly = true
                                    focus = false
                                }
                                onFocusChanged: fileFolderListView.currentIndex = index

                            }
                        }

                        Rectangle{
                            id: size
                            width: (parent.width - check.width - icon.width)*0.2
                            height: parent.height
                            color: "transparent"
                            Text {
                                width: parent.width
                                height: parent.height
                                text: model.modelData.FileSize
                                color: mainWindow.fontColor
                                font.family: "Sans Serif"
                                font.pointSize: Math.max(scaleFactor*0.16, 8)
                                anchors.verticalCenter: parent.verticalCenter
                                clip: true
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle{
                            id: dateTime
                            width: (parent.width - check.width - icon.width)*0.3
                            height: parent.height
                            color: "transparent"
                            Text {
                                width: parent.width
                                height: parent.height
                                text: model.modelData.Date_Time_Modified
                                color: mainWindow.fontColor
                                font.family: "Sans Serif"
                                font.pointSize: Math.max(scaleFactor*0.16, 8)
                                anchors.verticalCenter: parent.verticalCenter
                                clip: true
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                    }


                    Rectangle{
                        id: perItemActionMenu
                        visible: (fileFolderListView.currentIndex === index)
                        height: scaleFactor*0.8 + 4
                        width: scaleFactor*2.4 + 4
                        anchors.right: parent.right
                        anchors.rightMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: 0.75

                        Row{
                            anchors.fill: parent
                            anchors.margins: 2
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: 1
                            RImageButton{
                                id: renameBtn
                                width: parent.width/3
                                height: width
                                iconPath: "file:///home/eobardthawne/.icons/Papirus/32/apps/krename.svg"
                                hoverText: "Rename"
                                onClicked: {
                                    nameInput.readOnly = false
                                    fileFolderListView.editing = true
                                    nameInput.selectAll()
                                    nameInput.forceActiveFocus()
                                }
                            }
                            RImageButton{
                                id: deleteBtn
                                width: parent.width/3
                                height: width
                                iconPath: "file://" + rDesktopService.getThemeIcon("std-name:user-trash", 32)
                                hoverText: "Delete"
                                onClicked: qtModel.deleteFile(index)
                            }
                            RImageButton{
                                id: propertiesBtn
                                width: parent.width/3
                                height: width
                                iconPath: "/local/Resources/icons-switch.svg"
                                hoverText: "More Actions"
                                onClicked: actionMenu.open()

                                RMenu{
                                    id: actionMenu
                                    menuList: model.modelData.ActionsMenu
                                    height: (model.modelData.ActionsMenuCount)*26
                                    width: 200
                                    x: propertiesBtn.x - 220
                                    y: propertiesBtn.y + propertiesBtn.height
                                }
                            }
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        z: -1
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
                        onClicked: {
                            if(!fileFolderListView.focus)
                                fileFolderListView.forceActiveFocus()
                            fileFolderListView.currentIndex = index
                        }
                        onDoubleClicked: qtModel.updateCurrentDirectory(model.modelData.Path)
                    }

                    PropertyAnimation{
                        id: mouseEnteredAnimation
                        target: fileFolderListviewDelegate
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: "#9dcfe2"
                        duration: 250
                    }
                    PropertyAnimation{
                        id: mouseExitedAnimation
                        target: fileFolderListviewDelegate
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: "transparent"
                        duration: 250
                    }
                }

                highlightFollowsCurrentItem: true
                highlightMoveDuration: 1000
                highlight: Rectangle{
                    width: fileFolderListView.width
                    height: scaleFactor
                    color: "skyblue"
                    opacity: 0.5
                }

                ScrollIndicator.vertical: ScrollIndicator{}

                Keys.onPressed: {
                    if(!editing){
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                            qtModel.updateCurrentDirectory(currentItem.filePath)
                        else if(event.key === Qt.Key_Backspace && backBtn.enabled)
                            qtModel.navigateBackward()
                    }
                }

                onCurrentIndexChanged: {
                    editing = false
                    returnToIndex[returnToIndex.length - 1] = currentIndex
                }
            }
        }
    }
}