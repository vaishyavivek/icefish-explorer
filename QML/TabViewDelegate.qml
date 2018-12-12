import QtQml 2.1
import QtQuick 2.8
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import com.mimeinfoprovider 1.0
import com.rdirectorymodel 1.0

Rectangle{
    id: tabViewDelegate
    property int scaleFactor: qtModel.IconScale
    property var qtModel
    property int lastIndexPositions: []

    /*RDirectoryModel{
        id: qtModel
    }*/

    width: parent.width
    height: parent.height
    color: mainWindow.color

    Column{
        anchors.fill: parent
        //spacing: 5
        Row{
            width: parent.width
            height: 35

            RImageButton{
                id: backBtn
                height: parent.height
                width: height
                icon.source: "/local/assets/icons-move-back.svg"
                icon.color: enabled ? rFileSystem.IconColor : "#4d26282a"
                hoverText: "Move Backward"
                enabled: false
                onClicked: navigateBackward()
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
                icon.source: "/local/assets/icons-move-forward.svg"
                icon.color: enabled ? rFileSystem.IconColor : "#4d26282a"
                hoverText: "Move Forward"
                enabled: false
                onClicked: {
                    qtModel.navigateForward()
                    fileFolderListView.currentIndex = qtModel.ActiveIndexInCurrentModel
                }
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
                icon.source: "/local/assets/icons-reload.svg"
                icon.color: enabled ? rFileSystem.IconColor : "#4d26282a"
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
                clip: true
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

            Rectangle{
                id: defaultLayout
                opacity: visible ? 1 : 0
                visible: !selectAll.checked
                height: parent.height
                width: height*5
                anchors.left: parent.left
                anchors.leftMargin: 7
                color: "transparent"

                Row{
                    anchors.fill: parent
                    spacing: 1

                    RCheckBox{
                        id: selectAll
                        height: parent.height*0.75
                        width: height
                        checked: false
                    }

                    RImageButton{
                        id: newFileBtn
                        height: parent.height
                        width: height
                        icon.name: "x-office-document"
                        icon.color: "transparent"
                        hoverText: "New File"
                        Image {
                            id: newFileBtnAddImage
                            visible: false
                            source: "/local/assets/icons-add.svg"
                            sourceSize.width: parent.width*0.4
                            sourceSize.height: parent.height*0.4
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.rightMargin: 2
                        }
                        ColorOverlay{
                            z: 2
                            anchors.fill: newFileBtnAddImage
                            source: newFileBtnAddImage
                            color: rFileSystem.IconColor
                        }

                        onClicked: newFileDialogBox.open()

                        NewFileDialogBox{
                            id: newFileDialogBox
                            title: "New File"
                            currentPath: qtModel.AddressBoxData
                            width: 250
                            height: 155
                            y: newFileBtn.height
                        }
                    }

                    RImageButton{
                        id: newFolderBtn
                        height: parent.height
                        width: height
                        icon.name: "folder"
                        icon.color: "transparent"
                        hoverText: "New Folder"
                        Image {
                            id: newFolderBtnAddImage
                            visible: false
                            source: "/local/assets/icons-add.svg"
                            sourceSize.width: parent.width*0.4
                            sourceSize.height: parent.height*0.4
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.rightMargin: 2
                        }
                        ColorOverlay{
                            z: 2
                            anchors.fill: newFolderBtnAddImage
                            source: newFolderBtnAddImage
                            color: rFileSystem.IconColor
                        }

                        onClicked: newFolderDialogBox.open()

                        NewFolderDialogBox{
                            id: newFolderDialogBox
                            title: "New Folder"
                            currentPath: qtModel.AddressBoxData
                            width: 250
                            height: 155
                            y: newFolderBtn.height
                        }
                    }
                }
            }

            Rectangle{
                id: layoutWhenSelected
                opacity: visible ? 1 : 0
                visible: selectAll.checked
                height: parent.height
                width: height*5
                anchors.left: parent.left
                anchors.leftMargin: 7
                color: "transparent"

                Row{
                    anchors.fill: parent
                    spacing: 1

                    RImageButton{
                        id: deselectAll
                        height: parent.height
                        width: height
                        icon.source: "/local/assets/icons-back-arrow.svg"
                        icon.color: mainWindow.fontColor
                        onClicked: selectAll.checked = false
                    }
                }
            }

            Row{
                id: globalControls
                height: parent.height
                width: height*10 + 7
                anchors.right: parent.right
                anchors.rightMargin: 7
                spacing: 1

                RImageButton{
                    id: favoriteBtn
                    property bool isBookmarked: qtModel.IsBookmarked
                    height: parent.height
                    width: height
                    icon.name: "folder"
                    icon.color: "transparent"
                    hoverText: (isBookmarked ? "Remove Bookmark" : "Bookmark this place")
                    onClicked: qtModel.IsBookmarked = !isBookmarked

                    Image {
                        id: bookmarkIndicator
                        visible: false
                        source: "/local/assets/icons-bookmark-" + (favoriteBtn.isBookmarked ? "checked" : "unchecked") + ".svg"
                        sourceSize.width: parent.width*0.3
                        sourceSize.height: parent.height*0.5
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 2
                    }
                    ColorOverlay{
                        z: 2
                        anchors.fill: bookmarkIndicator
                        source: bookmarkIndicator
                        color: rFileSystem.IconColor
                    }
                }

                RImageButton{
                    id: showHiddenBtn
                    property bool nowVisible: qtModel.IsHiddenItemsShown
                    height: parent.height
                    width: height
                    icon.name: "folder"
                    icon.color: "transparent"
                    hoverText: (nowVisible ? "Hide Hidden Items" : "Show Hidden Items")
                    onClicked: qtModel.IsHiddenItemsShown = !nowVisible

                    Image {
                        id: visibleIndicator
                        visible: false
                        source: "/local/assets/icons-hidden-" + (showHiddenBtn.nowVisible ? "checked" : "unchecked") + ".svg"
                        sourceSize.width: parent.width*0.5
                        sourceSize.height: parent.height*0.4
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 2
                    }
                    ColorOverlay{
                        z: 2
                        anchors.fill: visibleIndicator
                        source: visibleIndicator
                        color: rFileSystem.IconColor
                    }
                }

                RImageButton{
                    id: imagePreviewBtn
                    property bool nowPreviewing: qtModel.IsPreviewAvailable
                    height: parent.height
                    width: height
                    icon.name: "image-x-generic"
                    icon.color: "transparent"
                    hoverText: (nowPreviewing ? "Stop Previewing items" : "Enable Image Preview")
                    onClicked: qtModel.IsPreviewAvailable = !nowPreviewing

                    Image {
                        id: previewIndicator
                        visible: false
                        source: "/local/assets/icons-image-preview-" + (imagePreviewBtn.nowPreviewing ? "checked" : "unchecked") + ".svg"
                        sourceSize.width: parent.width*0.5
                        sourceSize.height: parent.height*0.4
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 2
                    }
                    ColorOverlay{
                        z: 2
                        anchors.fill: previewIndicator
                        source: previewIndicator
                        color: rFileSystem.IconColor
                    }
                }

                RTextButton{
                    id: sortBtn
                    height: parent.height*0.75
                    width: parent.height*3.5
                    anchors.verticalCenter: parent.verticalCenter
                    text: sortPopup.currentSelection
                    checkable: false
                    hoverText: "Sort By"
                    onClicked: {
                        sortPopup.isOpened ? sortPopup.close() : sortPopup.open()
                        sortPopup.isOpened = !sortPopup.isOpened
                    }

                    SortingPanel{
                        id: sortPopup
                        width: sortBtn.width
                        oldY: sortBtn.y
                        newY: sortBtn.y + sortBtn.height
                    }
                }

                RScaleControlSpinBox{
                    id: scaleControl
                    height: parent.height*0.75
                    width: parent.height*3.5
                    anchors.verticalCenter: parent.verticalCenter
                    hoverText: "Icon Scale"
                    onValueModified: qtModel.IconScale = getValue()
                    value: setValue(qtModel.IconScale)
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
            height: parent.height - 92
            color: "transparent"
            ListView{
                id: fileFolderListView
                property bool editing: false
                property bool searching: false

                property int chechboxWidth: scaleFactor*0.5
                property int iconWidth: scaleFactor
                property int fileNameWidth: (width - scaleFactor*1.5)*0.35
                property int lastModifiedWidth: (width - scaleFactor*1.5)*0.12
                property int sizeWidth: (width - scaleFactor*1.5)*0.12
                property int typeWidth: (width - scaleFactor*1.5)*0.2

                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                clip: true
                keyNavigationEnabled: true
                model: qtModel.FileFolderList

                header: Rectangle{
                    width: parent.width
                    height: scaleFactor
                    color: rFileSystem.BackgroundColor
                    z: 2

                    Row{
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        spacing: 10

                        Rectangle{
                            id: space
                            height: parent.height*0.5
                            width: fileFolderListView.chechboxWidth + fileFolderListView.iconWidth + 10
                            color: "transparent"
                        }

                        Rectangle{
                            width: fileFolderListView.fileNameWidth
                            height: parent.height
                            color: "transparent"
                            clip: true

                            Text{
                                text: "File Name"
                                font.family: "Sans Serif"
                                color: rFileSystem.IconColor
                                font.pointSize: Math.max(scaleFactor*0.16, 8)
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle{
                                width: 1
                                height: parent.height*0.9
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                color: rFileSystem.HighlightColor
                                Drag.active: fileNameDrag.drag.active
                                MouseArea{
                                    id: fileNameDrag
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: cursorShape = Qt.SizeHorCursor
                                    onPressed: parent.anchors.right = undefined
                                    onReleased: parent.anchors.right = parent.parent.right
                                    drag.target: parent
                                }

                                onXChanged: if(x > 0) fileFolderListView.fileNameWidth = x
                            }
                        }


                        Rectangle{
                            width: fileFolderListView.lastModifiedWidth
                            height: parent.height
                            color: "transparent"
                            clip: true
                            Text{
                                text: "Last Modified"
                                font.family: "Sans Serif"
                                color: rFileSystem.IconColor
                                font.pointSize: Math.max(scaleFactor*0.16, 8)
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle{
                                width: 1
                                height: parent.height*0.9
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                color: rFileSystem.HighlightColor
                                Drag.active: lastModifiedDrag.drag.active
                                MouseArea{
                                    id: lastModifiedDrag
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: cursorShape = Qt.SizeHorCursor
                                    onPressed: parent.anchors.right = undefined
                                    onReleased: parent.anchors.right = parent.parent.right
                                    drag.target: parent
                                }

                                onXChanged: if(x > 0) fileFolderListView.lastModifiedWidth = x
                            }
                        }

                        Rectangle{
                            width: fileFolderListView.sizeWidth
                            height: parent.height
                            color: "transparent"
                            clip: true
                            Text{
                                text: "Size"
                                font.family: "Sans Serif"
                                color: rFileSystem.IconColor
                                font.pointSize: Math.max(scaleFactor*0.16, 8)
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle{
                                width: 1
                                height: parent.height*0.9
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                color: rFileSystem.HighlightColor
                                Drag.active: sizeDrag.drag.active
                                MouseArea{
                                    id: sizeDrag
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: cursorShape = Qt.SizeHorCursor
                                    onPressed: parent.anchors.right = undefined
                                    onReleased: parent.anchors.right = parent.parent.right
                                    drag.target: parent
                                }

                                onXChanged: if(x > 0) fileFolderListView.sizeWidth = x
                            }
                        }

                        Rectangle{
                            width: fileFolderListView.typeWidth
                            height: parent.height
                            color: "transparent"
                            clip: true
                            Text{
                                text: "Type"
                                font.family: "Sans Serif"
                                color: rFileSystem.IconColor
                                font.pointSize: Math.max(scaleFactor*0.16, 8)
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle{
                                width: 1
                                height: parent.height*0.9
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                color: rFileSystem.HighlightColor
                                Drag.active: typeDrag.drag.active
                                MouseArea{
                                    id: typeDrag
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: cursorShape = Qt.SizeHorCursor
                                    onPressed: parent.anchors.right = undefined
                                    onReleased: parent.anchors.right = parent.parent.right
                                    drag.target: parent
                                }

                                onXChanged: if(x > 0) fileFolderListView.typeWidth = x
                            }
                        }
                    }
                }

                headerPositioning: ListView.OverlayHeader

                delegate: Rectangle{
                    id: fileFolderListviewDelegate
                    property variant filePath: model.modelData.Path
                    property variant menuModel: model.modelData.ActionsMenu
                    width: parent.width
                    height: scaleFactor
                    color: "transparent"

                    Row{
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        spacing: 10

                        RCheckBox{
                            id: check
                            height: fileFolderListView.chechboxWidth
                            width: fileFolderListView.chechboxWidth
                            checked: selectAll.checked
                            onCheckedChanged: {
                                model.modelData.Checked = checked
                                //layoutWhenSelected.visible = checked
                                //defaultLayout.visible = checked
                            }
                        }

                        Rectangle{
                            id: iconRect
                            height: parent.height*0.9
                            width: fileFolderListView.iconWidth
                            color: "transparent"
                            Image {
                                id: iconImage
                                anchors.centerIn: parent
                                source: (imagePreviewBtn.nowPreviewing ? "image://preview/" : "image://mime/") + model.modelData.Path
                                sourceSize.width: parent.width*0.9
                                sourceSize.height: parent.height*0.9
                                asynchronous: true
                            }

                            ColorOverlay{
                                anchors.fill: iconImage
                                source: iconImage
                                color: model.modelData.IsHidden ? "#81abc7" : "transparent"
                            }
                        }

                        Rectangle{
                            id: displayName
                            width: fileFolderListView.fileNameWidth
                            height: parent.height
                            color: "transparent"
                            clip: true
                            TextInput {
                                id: nameInput
                                text: model.modelData.DisplayName
                                font.family: "Sans Serif"
                                color: rFileSystem.IconColor
                                font.pointSize: Math.max(scaleFactor*0.16, 8)
                                anchors.verticalCenter: parent.verticalCenter

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
                            id: dateTime
                            width: fileFolderListView.lastModifiedWidth
                            height: parent.height
                            color: "transparent"
                            Text {
                                width: parent.width
                                height: parent.height
                                text: model.modelData.Date_Time_Modified
                                color: rFileSystem.IconColor
                                font.family: "Sans Serif"
                                font.pointSize: Math.max(scaleFactor*0.16, 8)
                                anchors.verticalCenter: parent.verticalCenter
                                clip: true
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle{
                            id: size
                            width: fileFolderListView.sizeWidth
                            height: parent.height
                            color: "transparent"
                            Text {
                                width: parent.width
                                height: parent.height
                                text: model.modelData.FileSize
                                color: rFileSystem.IconColor
                                font.family: "Sans Serif"
                                font.pointSize: Math.max(scaleFactor*0.16, 8)
                                anchors.verticalCenter: parent.verticalCenter
                                clip: true
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle{
                            id: type
                            width: fileFolderListView.typeWidth
                            height: parent.height
                            color: "transparent"

                            /*MimeInfoProvider{
                                id: mip
                                FilePath: model.modelData.Path
                            }*/

                            Text {
                                width: parent.width
                                height: parent.height
                               // text: mip.MimeShortInfo
                                color: rFileSystem.IconColor
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
                        visible: (fileFolderListView.currentIndex === index && !selectAll.checked)
                        height: parent.height
                        width: height*3 + 10
                        color: "transparent"
                        anchors.right: parent.right

                        Row{
                            anchors.fill: parent
                            RImageButton{
                                id: renameBtn
                                height: parent.height
                                width: height
                                icon.source: "/local/assets/icons-rename.svg"
                                icon.color: rFileSystem.IconColor
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
                                height: parent.height
                                width: height
                                icon.source: "/local/assets/icons-trash.svg"
                                icon.color: rFileSystem.IconColor
                                hoverText: "Delete"
                                onClicked: qtModel.deleteFile(index)
                            }
                            RImageButton{
                                id: actionBtn
                                height: parent.height
                                width: height
                                icon.source: "/local/assets/icons-switch.svg"
                                icon.color: rFileSystem.IconColor
                                hoverText: "More Actions"
                                onClicked: {
                                    model.modelData.ActionsMenu = qtModel.getActionMenuFor(model.modelData.Path)
                                    actionMenu.open()
                                }

                                RMenu{
                                    id: actionMenu
                                    menuList: model.modelData.ActionsMenu
                                    filePath: model.modelData.Path
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
                        onClicked: fileFolderListView.currentIndex = index

                        onDoubleClicked: updateModel(model.modelData.Path, index)
                    }

                    Rectangle{
                        id: animatingRect
                        anchors.fill: parent
                        opacity: 0.3
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

                highlightFollowsCurrentItem: true
                highlightMoveVelocity: -1
                highlightMoveDuration: 400

                highlight: Rectangle{
                    width: fileFolderListView.width
                    height: scaleFactor
                    color: rFileSystem.HighlightColor
                    opacity: 0.4
                    Rectangle{
                        width: 5
                        height: parent.height
                        color: rFileSystem.IconColor
                    }
                }

                ScrollIndicator.vertical: ScrollIndicator{}

                Keys.onPressed: {
                    if(!editing){
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                            updateModel(currentItem.filePath, currentIndex)
                        else if(event.key === Qt.Key_Backspace){
                            if(searching)
                                wildSearchPanel.searchKey = wildSearchPanel.searchKey.substring(0, wildSearchPanel.searchKey.length - 1)
                            else if(backBtn.enabled)
                                navigateBackward()
                        }
                        else if(event.key >= Qt.Key_A && event.key <= Qt.Key_Z){
                            searching = true
                            wildSearchPanel.searchKey += String.fromCharCode(event.key)
                            wildSearchPanel.open()
                        }
                    }
                }

                onCurrentIndexChanged: editing = false

                onModelChanged: {
                    if(!fileFolderListView.focus)
                        fileFolderListView.forceActiveFocus()
                }
            }
        }
    }

    WildSearchPanel{
        id: wildSearchPanel
        width: parent.width*0.5
        height: 20
        x: parent.width/2 - width/2
        oldY: parent.height
        newY: parent.height - height - 10
    }

    PropertiesPanel{
        id: propertiesPanel
        x: parent.width/2 - width/2
        y: parent.height/2 - height/2

        Connections{
            target: qtModel
            ignoreUnknownSignals: true
            onShowProperties: propertiesPanel.open()
        }
    }

    function navigateBackward(){
        //c++ will update the list
        qtModel.navigateBackward()

        //set the highlight movement to maximum so that there's no time lapse in update
        fileFolderListView.highlightMoveDuration = 10

        //now change to the last active index in the model
        fileFolderListView.currentIndex = qtModel.ActiveIndexInCurrentModel

        //set the highlight to default values
        fileFolderListView.highlightMoveDuration = 400
    }

    function updateModel(newPath, index){
        qtModel.ActiveIndexInCurrentModel = index
        qtModel.updateCurrentDirectory(newPath)
        wildSearchPanel.close()
    }
}
