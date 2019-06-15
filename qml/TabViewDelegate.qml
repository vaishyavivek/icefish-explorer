/*This file is part of IceFish Explorer.

    IceFish Explorer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IceFish Explorer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with IceFish Explorer. If not, see <http://www.gnu.org/licenses/>.
*/
import QtQml 2.1
import QtQuick 2.8
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import com.mimeinfoprovider 1.0
//import com.rdirectorymodel 1.0
import "CustomComponents"
import "AddressBarComponents"
import "Popups"

Rectangle{
    id: tabViewDelegate
    property var qtModel
    property int scaleFactor: qtModel.IconScale
    property real highlightMoveDuration: rFileSystem.GlobalAnimationDuration*0.5
    property bool editing: false
    property bool searching: false
    property int selectionCount: 0
    property var currentItem
    property int currentIndex

    /*RDirectoryModel{
        id: qtModel
    }*/

    width: parent.width
    height: parent.height
    color: rFileSystem.BackgroundColor1

    Column{
        anchors.fill: parent
        spacing: 2

        Row{
            width: parent.width
            height: 35
            spacing: 2

            RImageButton{
                id: backBtn
                height: parent.height
                width: height
                icon.source: "/local/assets/move-back.svg"
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
                icon.source: "/local/assets/move-forward.svg"
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
                icon.source: "/local/assets/reload.svg"
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
                width: parent.width - (parent.height + 2)*3
                height: parent.height
                clip: true
            }
        }

        Rectangle{
            id: separator1
            color: rFileSystem.BackgroundColor2
            opacity: 0.1
            height: 1
            width: parent.width
        }

        Rectangle{
            id: fileFolderListViewHeaderRect
            width: parent.width
            height: 35
            color: "transparent"
            visible: fileFolderView.sourceComponent != startPage

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
                    spacing: 5

                    RCheckBox{
                        id: selectAll
                        height: parent.height*0.75
                        width: height
                        checked: selectionCount === qtModel.FileFolderListCount
                        Component.onCompleted: checked = false
                        onCheckedChanged: selectionCount = qtModel.FileFolderListCount
                    }

                    RImageButton{
                        id: newFileBtn
                        height: parent.height
                        width: height
                        icon.source: "/local/assets/new-file.svg"
                        icon.color: rFileSystem.IconColor
                        hoverText: "New File"
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
                        icon.source: "/local/assets/new-folder.svg"
                        icon.color: rFileSystem.IconColor
                        hoverText: "New Folder"
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
                        icon.source: "/local/assets/paste.svg"
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
                    spacing: 5

                    RImageButton{
                        id: deselectAll
                        height: parent.height
                        width: height
                        icon.source: "/local/assets/back-arrow.svg"
                        icon.color: rFileSystem.IconColor
                        onClicked: {
                            selectAll.checked = false
                            selectionCount = 0
                            layoutWhenSelected.visible = false
                            defaultLayout.visible = true
                            reloadView()
                        }
                    }

                    RImageButton{
                        id: copyItems
                        height: parent.height
                        width: height
                        icon.source: "/local/assets/copy.svg"
                        icon.color: rFileSystem.IconColor
                        hoverText: "Copy " + selectionCount + " Item" + (selectionCount == 1 ? "" : "s")
                        onClicked: qtModel.copyOrCutItems(0)
                    }

                    RImageButton{
                        id: moveItems
                        height: parent.height
                        width: height
                        icon.source: "/local/assets/cut.svg"
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
                width: height*12 + 7
                anchors.right: parent.right
                anchors.rightMargin: 7
                spacing: 5

                RImageButton{
                    id: favoriteBtn
                    property bool isBookmarked: qtModel.IsBookmarked
                    height: parent.height
                    width: height
                    icon.source: "/local/assets/bookmark-" + (isBookmarked ? "checked" : "unchecked") + ".svg"
                    icon.color: rFileSystem.IconColor
                    hoverText: (isBookmarked ? "Remove Bookmark" : "Bookmark this place")
                    onClicked: qtModel.IsBookmarked = !isBookmarked
                }

                RImageButton{
                    id: showHiddenBtn
                    property bool nowVisible: qtModel.IsHiddenItemsShown
                    height: parent.height
                    width: height
                    icon.source: "/local/assets/hidden-" + (nowVisible ? "checked" : "unchecked") + ".svg"
                    icon.color: rFileSystem.IconColor
                    hoverText: (nowVisible ? "Hide Hidden Items" : "Show Hidden Items")
                    onClicked: qtModel.IsHiddenItemsShown = !nowVisible
                }

                RImageButton{
                    id: imagePreviewBtn
                    property bool nowPreviewing: qtModel.IsPreviewAvailable
                    height: parent.height
                    width: height
                    icon.source: "/local/assets/image-preview-" + (nowPreviewing ? "checked" : "unchecked") + ".svg"
                    icon.color: rFileSystem.IconColor
                    hoverText: (nowPreviewing ? "Stop Previewing items" : "Enable Image Preview")
                    onClicked: qtModel.IsPreviewAvailable = !nowPreviewing
                }

                RImageButton{
                    id: viewBtn
                    property int currentView: qtModel.CurrentView
                    height: parent.height
                    width: height
                    icon.source: "/local/assets/" + (currentView == 0 ? "list" : "grid") + "view.svg"
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
                    hoverText: "Sort By"
                    checked: sortPopup.isOpened
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


                RSlider{
                    id: scaleControl
                    height: parent.height*0.75
                    width: parent.height*4
                    anchors.verticalCenter: parent.verticalCenter
                    from: 32
                    to: 128
                    stepSize: 16
                    hoverText: "Icon Scale"
                    onValueChanged: qtModel.IconScale = value
                    value: qtModel.IconScale
                }
            }
        }

        Rectangle{
            id: separator
            color: rFileSystem.BackgroundColor2
            opacity: 0.1
            height: 1
            width: parent.width
        }

        Rectangle{
            id: fileFolderListViewParentRect

            width: parent.width
            height: parent.height - 92
            color: "transparent"
            anchors.leftMargin: 10
            anchors.rightMargin: 10


            FocusScope{
                id: fileFolderViewFocus
                anchors.fill: parent
                focus: tabViewDelegate.focus
                Loader{
                    id: fileFolderView
                    property int currentIndex: 0
                    property int currentIndexForReloading: 0
                    anchors.fill: parent
                    sourceComponent: qtModel.FileFolderListCount === 0 ? emptyComp : (qtModel.CurrentView === 0 ? fileFolderListView : fileFolderGridView)

                    StartPage{
                        id: startPage
                    }

                    FileFolderListView{
                        id: fileFolderListView
                    }

                    FileFolderGridView{
                        id: fileFolderGridView
                    }

                    Component{
                        id: emptyComp
                        Rectangle{
                            anchors.fill: parent
                            color: rFileSystem.BackgroundColor
                            anchors.topMargin: 50
                            Text {
                                width: parent.width
                                text: qsTr("This directory is empty")
                                color: rFileSystem.IconColor
                                font.pointSize: 11
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }

                Keys.onPressed: {
                    //console.log(event.key)
                    if(!editing){
                        event.accepted = true
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
