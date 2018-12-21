import QtQml 2.1
import QtQuick 2.8
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import com.mimeinfoprovider 1.0
import com.rdirectorymodel 1.0
import "CustomComponents"
import "AddressBarComponents"
import "Popups"

Rectangle{
    id: tabViewDelegate
    property var qtModel
    property int scaleFactor: qtModel.IconScale
    property real highlightMoveDuration: rFileSystem.GlobalAnimationDuration
    property bool editing: false
    property bool searching: false
    property int selectionCount: 0
    property int totalModelCount: 0
    //property alias focus: fileFolderViewFocus.focus

    /*RDirectoryModel{
        id: qtModel
    }*/

    width: parent.width
    height: parent.height
    color: rFileSystem.BackgroundColor

    Rectangle{
        width: parent.width
        height: 92
        opacity: 0.2
        color: rFileSystem.HighlightColor
    }

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
                onClicked: reloadView()//qtModel.reloadCurrentDirectory()
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
            color: rFileSystem.IconColor
        }

        Rectangle{
            id: fileFolderListViewHeaderRect
            width: parent.width
            height: 35
            color: "transparent"

            Rectangle{
                id: defaultLayout
                opacity: visible ? 1 : 0
                visible: selectionCount  == 0
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
                        checked: selectionCount == totalModelCount
                        Component.onCompleted: checked = false
                    }

                    RImageButton{
                        id: newFileBtn
                        height: parent.height
                        width: height
                        //icon.name: "x-office-document"
                        icon.source: "/local/assets/icons-file.svg"
                        icon.color: rFileSystem.IconColor
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
                        //icon.name: "folder"
                        icon.source: "/local/assets/icons-folder.svg"
                        icon.color: rFileSystem.IconColor
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

                    RImageButton{
                        id: pasteItems
                        height: parent.height
                        width: height
                        visible: qtModel.ClipboardContentCount > 0
                        icon.source: "/local/assets/icons-paste.svg"
                        icon.color: rFileSystem.IconColor
                        hoverText: (qtModel.ClipboardOperationType === 0 ? "Copy " : "Move ") + qtModel.ClipboardContentCount + " Item"
                                   + (qtModel.ClipboardContentCount === 1 ? "" : "s") + " Here"
                        onClicked: {
                            switch(qtModel.ClipboardOperationType){
                            case 0:
                                rFileOperator.copyFiles(qtModel.AddressBoxData)
                                break;
                            case 1:
                                rFileOperator.moveFiles(qtModel.AddressBoxData)
                            }
                        }
                    }
                }

                Behavior on opacity { PropertyAnimation{ duration: rFileSystem.GlobalAnimationDuration}}
            }

            Rectangle{
                id: layoutWhenSelected
                opacity: visible ? 1 : 0
                visible: selectionCount > 0
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
                        icon.color: rFileSystem.IconColor
                        onClicked: {
                            selectAll.checked = false
                            selectionCount = 0
                            reloadView()
                        }
                    }

                    RImageButton{
                        id: copyItems
                        height: parent.height
                        width: height
                        icon.source: "/local/assets/icons-copy.svg"
                        icon.color: rFileSystem.IconColor
                        hoverText: "Copy " + selectionCount + " Item" + (selectionCount == 1 ? "" : "s")
                        onClicked: qtModel.copyOrCutItems(0)
                    }

                    RImageButton{
                        id: moveItems
                        height: parent.height
                        width: height
                        icon.source: "/local/assets/icons-cut.svg"
                        icon.color: rFileSystem.IconColor
                        hoverText: "Cut " + selectionCount + " Item" + (selectionCount == 1 ? "" : "s")
                        onClicked: qtModel.copyOrCutItems(1)
                    }
                }

                Behavior on opacity { PropertyAnimation{ duration: rFileSystem.GlobalAnimationDuration}}
            }

            Row{
                id: globalControls
                height: parent.height
                width: height*11 + 7
                anchors.right: parent.right
                anchors.rightMargin: 7
                spacing: 1

                RImageButton{
                    id: favoriteBtn
                    property bool isBookmarked: qtModel.IsBookmarked
                    height: parent.height
                    width: height
                    //icon.name: "directory"
                    icon.source: "/local/assets/icons-bookmark.svg"
                    icon.color: rFileSystem.IconColor
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
                    //icon.name: "folder"
                    icon.source: "/local/assets/icons-folder.svg"
                    icon.color: rFileSystem.IconColor
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
                    //icon.name: "image-x-generic"
                    icon.source: "/local/assets/icons-folder.svg"
                    icon.color: rFileSystem.IconColor
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

                RImageButton{
                    id: viewBtn
                    property int currentView: qtModel.CurrentView
                    height: parent.height
                    width: height
                    icon.source: "/local/assets/icons-" + (currentView == 0 ? "list" : "grid") + "view.svg"
                    icon.color: rFileSystem.IconColor
                    hoverText: (currentView == 0 ? "Switch to GridView" : "Switch to ListView")
                    onClicked: qtModel.CurrentView = (currentView == 0) ? 1 : 0
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
            color: rFileSystem.IconColor
        }

        Rectangle{
            id: fileFolderListViewParentRect

            width: parent.width
            height: parent.height - 92
            color: "transparent"


            FocusScope{
                id: fileFolderViewFocus
                anchors.fill: parent
                focus: tabViewDelegate.focus
                Loader{
                    id: fileFolderView
                    property int currentIndex: 0
                    property int currentIndexForReloading: 0
                    anchors.fill: parent
                    sourceComponent: (qtModel.CurrentView === 0) ? fileFolderListView : fileFolderGridView

                    FileFolderListView{
                        id: fileFolderListView
                    }

                    FileFolderGridView{
                        id: fileFolderGridView
                    }
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
        onClosed: searching = false
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
        highlightMoveDuration = 10

        //now change to the last active index in the model
        fileFolderView.currentIndex = qtModel.ActiveIndexInCurrentModel

        //set the highlight to default values
        highlightMoveDuration = rFileSystem.GlobalAnimationDuration
    }

    function reloadView(){
        var index = fileFolderView.currentIndexForReloading
        qtModel.reloadCurrentDirectory()
        //set the highlight movement to maximum so that there's no time lapse in update
        highlightMoveDuration = 10

        //now change to the last active index in the model
        fileFolderView.currentIndex = index

        //set the highlight to default values
        highlightMoveDuration = rFileSystem.GlobalAnimationDuration
    }

    function updateModel(newPath, index){
        qtModel.ActiveIndexInCurrentModel = index
        qtModel.updateCurrentDirectory(newPath)
        wildSearchPanel.close()
    }

    //onFocusChanged: fileFolderViewFocus.forceActiveFocus()

    Connections{
        target: qtModel
        ignoreUnknownSignals: true
        onRequestToReloadFromQml: reloadView()
    }
}
