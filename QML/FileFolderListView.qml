import QtQuick 2.8
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0


Component{
    ListView{
        id: fileFolderListView

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
        //currentIndex: fileFolderView.currentIndex

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
                        text: model.modelData.FileType
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
                radius: 5
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
        highlightMoveDuration: tabViewDelegate.highlightMoveDuration

        highlight: Rectangle{
            width: fileFolderListView.width
            height: scaleFactor
            color: rFileSystem.HighlightColor
            opacity: 0.4
            radius: 5
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

        Connections{
            target: fileFolderView
            ignoreUnknownSignals: true
            onCurrentIndexChanged: fileFolderListView.currentIndex = fileFolderView.currentIndex
        }
    }
}


