import QtQuick 2.8
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "CustomComponents"
import "Popups"
import com.rdialogbox 1.0
//import Qt.labs.folderlistmodel 2.2


ApplicationWindow{
    id: app
    width: 650
    height: 500
    visible: true


    Dialog{
        id: fileFolderSelectionDialogBox
        width: 600
        height: 480
        padding: 0
        //margins: 0

        RDialogBox{
            id: rDialogBox
            header: "Save File"
        }

        contentItem:  Rectangle{
            width: parent.width
            height: parent.height
            color: rDialogBox.BackgroundColor
            Column{
                anchors.fill: parent
                anchors.margins: 5
                spacing: 2
                Rectangle{
                    id: headerRect
                    color: rDialogBox.IconColor
                    width: parent.width
                    height: parent.height*0.05

                    Row{
                        anchors.fill: parent
                        Rectangle{
                            width: parent.width - height
                            height: parent.height
                            anchors.leftMargin: 5
                            color: "transparent"
                            Text {
                                width: parent.width
                                height: parent.height
                                text: "   " + rDialogBox.header
                                color: rDialogBox.BackgroundColor
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RImageButton{
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/icons-close.svg"
                            icon.color: rDialogBox.BackgroundColor
                            onClicked: fileFolderSelectionDialogBox.close()
                        }
                    }
                }

                Rectangle{
                    id: directoryControlPanel
                    width: parent.width
                    height: parent.height*0.07
                    color: "transparent"
                    Row{
                        anchors.fill: parent
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        spacing: 5
                        TextField{
                            id: currentDirectoryIndicator
                            width: parent.width*0.6
                            height: parent.height
                            text: rDialogBox.currentPath
                            onAccepted: rDialogBox.updateDirectory(text)
                        }

                        RImageButton{
                            id: cdupBtn
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/icons-cd-up.svg"
                            icon.color: rDialogBox.IconColor
                            hoverText: "Move One Level Up"
                        }

                        RImageButton{
                            id: backBtn
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/icons-move-back.svg"
                            icon.color: (enabled ? rDialogBox.IconColor : "#4d26282a")
                            hoverText: "Go Back"
                            enabled: rDialogBox.backNavBtnEnabled
                            onClicked: rDialogBox.navigateBackward()
                        }

                        RImageButton{
                            id: forwardBtn
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/icons-move-forward.svg"
                            icon.color: (enabled ? rDialogBox.IconColor : "#4d26282a")
                            hoverText: "Go Forward"
                            enabled: rDialogBox.forNavBtnEnabled
                            onClicked: rDialogBox.navigateForward()
                        }

                        RImageButton{
                            id: showHiddenBtn
                            property bool hidden: false
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/icons-hidden-" + (hidden ? "checked" :"unchecked.svg")
                            icon.color: rDialogBox.IconColor
                            hoverText: (hidden ? "Stop Showing Hidden Items" :"Show Hidden Items")
                            onClicked: hidden = !hidden
                        }
                        RImageButton{
                            id: viewBtn
                            property bool currentView: false
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/icons-" + (currentView ? "list" : "grid") + "view.svg"
                            icon.color: rDialogBox.IconColor
                            hoverText: (currentView ? "ListView" : "GridView")
                            onClicked: currentView = !currentView
                        }
                        RImageButton{
                            id: imagePreviewBtn
                            property bool nowPreviewing: false
                            height: parent.height
                            width: height
                            icon.source: "/local/assets/icons-image-preview-" + (nowPreviewing ? "checked.svg" :"unchecked.svg")
                            icon.color: rDialogBox.IconColor
                            hoverText: (nowPreviewing ? "Stop Showing Preview" : "Enable Preview")
                            onClicked: nowPreviewing = !nowPreviewing
                        }
                    }
                }

                Rectangle{
                    width: parent.width
                    height: 2
                    color: rDialogBox.IconColor
                    opacity: 0.5
                }

                Rectangle{
                    id: bodyRect
                    width: parent.width
                    height: parent.height*0.73 - 14
                    color: "transparent"
                    Row{
                        anchors.fill: parent
                        spacing: 5
                        Rectangle{
                            id: sideBar
                            width: parent.width*0.2
                            height: parent.height
                            color: "transparent"

                            ListView{
                                id: sideBarListView
                                property string home: rDialogBox.homePath
                                anchors.fill: parent
                                anchors.margins: 5
                                clip: true

                                delegate: Rectangle{
                                    id: sideBarListViewDelegate
                                    width: parent.width
                                    height: 30
                                    color: "transparent"
                                    Row{
                                        anchors.fill: parent
                                        anchors.leftMargin: 10
                                        spacing: 5

                                        Rectangle{
                                            id: iconRect
                                            height: parent.height
                                            width: height
                                            color: "transparent"
                                            Image {
                                                id: iconImage
                                                anchors.centerIn: parent
                                                source: "image://xdg/" + model.icon
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
                                            id: nameRect
                                            width: parent.width - iconRect.width
                                            height: parent.height
                                            color: "transparent"
                                            Text {
                                                width: parent.width
                                                height: parent.height
                                                text: model.name
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                        }
                                    }

                                    MouseArea{
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onEntered: mouseEnteredAnimation.start()
                                        onExited: mouseExitedAnimation.start()
                                        onClicked: sideBarListView.currentIndex = index
                                        onDoubleClicked: {
                                            if(model.path === "/")
                                                rDialogBox.updateDirectory(model.path)
                                            else
                                                rDialogBox.updateDirectory(rDialogBox.homePath + "/" + model.path)
                                        }
                                    }

                                    Rectangle{
                                        id: animatingRect
                                        anchors.fill: parent
                                        radius: 5
                                        opacity: 0.3
                                        color: "transparent"
                                    }


                                    PropertyAnimation{
                                        id: mouseEnteredAnimation
                                        target: animatingRect
                                        property: "color"
                                        easing.type: Easing.OutInQuad
                                        to: rDialogBox.HighlightColor
                                        duration: rDialogBox.AnimationDuration
                                    }
                                    PropertyAnimation{
                                        id: mouseExitedAnimation
                                        target: animatingRect
                                        property: "color"
                                        easing.type: Easing.OutInQuad
                                        to: "transparent"
                                        duration: rDialogBox.AnimationDuration
                                    }
                                }

                                highlightFollowsCurrentItem: true

                                highlight: Rectangle{
                                    width: sideBarListView.width
                                    height: 40
                                    color: rDialogBox.HighlightColor
                                    opacity: 0.4
                                    radius: 5
                                    Rectangle{
                                        width: 5
                                        height: parent.height
                                        color: rDialogBox.IconColor
                                    }
                                }

                                model: ListModel{
                                    ListElement{
                                        icon: "inode-directory"
                                        name: "Root"
                                        path: "/"
                                    }
                                    ListElement{
                                        icon: "user-home"
                                        name: "Home"
                                        path: ""
                                    }
                                    ListElement{
                                        icon: "folder-documents"
                                        name: "Documents"
                                        path: "Documents"
                                    }
                                    ListElement{
                                        icon: "folder-downloads"
                                        name: "Downloads"
                                        path: "Downloads"
                                    }
                                    ListElement{
                                        icon: "network-workgroup"
                                        name: "Network"
                                        path: "network"
                                    }
                                }
                                currentIndex: 1
                            }
                        }

                        Rectangle{
                            width: 2
                            height: parent.height
                            color: rDialogBox.IconColor
                            opacity: 0.5
                        }

                        Rectangle{
                            id: mainPanel
                            width: parent.width*0.8
                            height: parent.height
                            color: "transparent"
                            FocusScope{
                                id: fileFolderViewFocus
                                anchors.fill: parent

                                Loader{
                                    anchors.fill: parent
                                    sourceComponent: viewBtn.currentView ? listViewComp : gridViewComp

                                    Component{
                                        id: listViewComp
                                        ListView{
                                            id: listView
                                            anchors.fill: parent
                                            model: rDialogBox.DirectoryList
                                            anchors.margins: 5
                                            clip: true

                                            delegate: Rectangle{
                                                id: listViewDelegate
                                                width: parent.width
                                                height: 40
                                                color: "transparent"
                                                Row{
                                                    anchors.fill: parent
                                                    anchors.leftMargin: 10
                                                    spacing: 5

                                                    Rectangle{
                                                        id: iconRect
                                                        height: parent.height
                                                        width: height
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
                                                        id: nameRect
                                                        width: parent.width - iconRect.width
                                                        height: parent.height
                                                        color: "transparent"
                                                        Text {
                                                            width: parent.width
                                                            height: parent.height
                                                            text: model.modelData.DisplayName
                                                            color: rDialogBox.IconColor
                                                            verticalAlignment: Text.AlignVCenter
                                                        }
                                                    }
                                                }

                                                MouseArea{
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    onEntered: mouseEnteredAnimation.start()
                                                    onExited: mouseExitedAnimation.start()
                                                    onClicked: listView.currentIndex = index
                                                    onDoubleClicked: rDialogBox.updateDirectory(model.modelData.Path)
                                                }

                                                Rectangle{
                                                    id: animatingRect
                                                    anchors.fill: parent
                                                    radius: 5
                                                    opacity: 0.3
                                                    color: "transparent"
                                                }


                                                PropertyAnimation{
                                                    id: mouseEnteredAnimation
                                                    target: animatingRect
                                                    property: "color"
                                                    easing.type: Easing.OutInQuad
                                                    to: rDialogBox.HighlightColor
                                                    duration: rDialogBox.AnimationDuration
                                                }
                                                PropertyAnimation{
                                                    id: mouseExitedAnimation
                                                    target: animatingRect
                                                    property: "color"
                                                    easing.type: Easing.OutInQuad
                                                    to: "transparent"
                                                    duration: rDialogBox.AnimationDuration
                                                }
                                            }

                                            highlightFollowsCurrentItem: true

                                            highlight: Rectangle{
                                                width: listView.width
                                                height: 40
                                                color: rDialogBox.HighlightColor
                                                opacity: 0.4
                                                radius: 5
                                                Rectangle{
                                                    width: 5
                                                    height: parent.height
                                                    color: rDialogBox.IconColor
                                                }
                                            }

                                            ScrollIndicator.vertical: ScrollIndicator{}
                                        }
                                    }

                                    Component{
                                        id: gridViewComp
                                        GridView{
                                            id: gridView
                                            anchors.fill: parent
                                            model: rDialogBox.DirectoryList
                                            anchors.margins: 5
                                            clip: true
                                            cellWidth: 60
                                            cellHeight: 90

                                            delegate: Rectangle{
                                                width: 50
                                                height: 80
                                                color: "transparent"

                                                Column{
                                                    anchors.fill: parent
                                                    spacing: 5

                                                    Rectangle{
                                                        id: iconRect
                                                        height: width
                                                        width: parent.width
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
                                                        id: nameRect
                                                        width: parent.width
                                                        height: parent.height - iconRect.height
                                                        color: "transparent"
                                                        Text {
                                                            width: parent.width
                                                            height: parent.height
                                                            text: model.modelData.DisplayName
                                                            color: rDialogBox.IconColor
                                                            horizontalAlignment: Text.AlignHCenter
                                                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                                            clip: true
                                                        }
                                                    }
                                                }

                                                MouseArea{
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    onEntered: mouseEnteredAnimation.start()
                                                    onExited: mouseExitedAnimation.start()
                                                    onClicked: gridView.currentIndex = index
                                                    onDoubleClicked: rDialogBox.updateDirectory(model.modelData.Path)
                                                }

                                                Rectangle{
                                                    id: animatingRect
                                                    anchors.fill: parent
                                                    radius: 5
                                                    opacity: 0.3
                                                    color: "transparent"
                                                }

                                                PropertyAnimation{
                                                    id: mouseEnteredAnimation
                                                    target: animatingRect
                                                    property: "color"
                                                    easing.type: Easing.OutInQuad
                                                    to: rDialogBox.HighlightColor
                                                    duration: rDialogBox.AnimationDuration
                                                }
                                                PropertyAnimation{
                                                    id: mouseExitedAnimation
                                                    target: animatingRect
                                                    property: "color"
                                                    easing.type: Easing.OutInQuad
                                                    to: "transparent"
                                                    duration: rDialogBox.AnimationDuration
                                                }
                                            }

                                            highlightFollowsCurrentItem: true

                                            highlight: Rectangle{
                                                width: 50
                                                height: 80
                                                color: rDialogBox.HighlightColor
                                                opacity: 0.4
                                                radius: 5
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle{
                    width: parent.width
                    height: 2
                    color: rDialogBox.IconColor
                    opacity: 0.5
                }

                Rectangle{
                    id: controlRect
                    width: parent.width
                    height: parent.height*0.15
                    color: "transparent"
                    Column{
                        anchors.fill: parent
                        spacing: 10
                        Row{
                            width: parent.width*0.9
                            height: parent.height*0.4
                            spacing: 5
                            anchors.horizontalCenter: parent.horizontalCenter
                            TextField{
                                id: currentSelectionNames
                                width: parent.width - height
                                height: parent.height
                            }
                            RImageButton{
                                id: newFolderBtn
                                height: parent.height
                                width: height
                                icon.source: "/local/assets/icons-folder.svg"
                                icon.color: rDialogBox.IconColor
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
                                    color: rDialogBox.IconColor
                                }

                                onClicked: newFolderDialogBox.open()

                                NewFolderDialogBox{
                                    id: newFolderDialogBox
                                    title: "New Folder"
                                    //currentPath: qtModel.AddressBoxData
                                    width: 250
                                    height: 155
                                    y: newFolderBtn.height
                                }
                            }
                        }


                        Row{
                            width: parent.width*0.9
                            height: parent.height*0.5
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 10
                            RComboBox{
                                id: showList
                                width: parent.width*0.3
                                height: parent.height
                                model: ["Show All", "Text Files"]
                            }
                            Rectangle{
                                width: parent.width*0.2
                                height: parent.height
                                color: "transparent"
                            }

                            RTextButton{
                                id: okayBtn
                                width: parent.width*0.25
                                height: parent.height
                                text: "Okay"
                            }
                            RTextButton{
                                id: cancelBtn
                                width: parent.width*0.25
                                height: parent.height
                                text: "Cancel"
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: fileFolderSelectionDialogBox.open()
}


