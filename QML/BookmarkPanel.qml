import QtQuick 2.7
import QtQuick.Controls 2.2

Popup{
    id: bookmarkPanel
    padding: 0
    property int widthWhenExpanded
    property bool isOpened: false

    clip: true
    closePolicy: Popup.NoAutoClose

    Rectangle{
        id: bookmarkPanelParentRect
        width: parent.width
        height: parent.height
        border.width: 1
        color: mainWindow.color
        Column{
            anchors.fill: parent
            spacing: 5
            Rectangle{
                id: headerBar
                width: parent.width
                height: 35
                color: "transparent"
                Rectangle{
                    id: titleRect
                    height: parent.height
                    width: parent.width - closeBtn.width
                    anchors.leftMargin: 5
                    Text {
                        text: "  Bookmarks"
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: 12
                        color: mainWindow.fontColor
                    }
                }
                RImageButton{
                    id: closebtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    icon.name: "application-exit"//"/local/Resources/icons-close.svg"
                    icon.color: mainWindow.fontColor
                    onClicked: {
                        isOpened = false
                        bookmarkPanel.close()
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

            ListView{
                id: bookmarkList
                width: parent.width
                height: parent.height - headerBar.height - 4
                model: rFileSystem.BookmarkDataList

                delegate: Rectangle{
                    id: bookmarkListDelegate
                    width: bookmarkList.width
                    height: 25
                    color: "transparent"
                    Row{
                        anchors.fill: parent
                        Rectangle{
                            id: icon
                            height: parent.height
                            width: height
                            color: "transparent"
                            Image {
                                anchors.centerIn: parent
                                source: model.modelData.IconPath
                                sourceSize.width: parent.width*0.9
                                sourceSize.height: parent.height*0.9
                            }
                        }
                        Rectangle{
                            id: name
                            width: parent.width - icon.width - removeBtn.width
                            height: parent.height
                            color: "transparent"
                            Text {
                                width: parent.width
                                height: parent.height
                                text: model.modelData.DisplayName
                                font.family: "Sans Serif"
                                color: mainWindow.fontColor
                                anchors.verticalCenter: parent.verticalCenter
                                clip: true
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }
                        }
                        RImageButton{
                            id: removeBtn
                            height: parent.height
                            width: height
                            iconPath: "/local/Resources/icons-close.svg"
                            onClicked: {
                                bookmarkListDelegate.visible = false
                                rFileSystem.writeBookmarkAsync(model.modelData.ActualPath, false)
                            }
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        z: -1
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
                        onClicked: bookmarkList.currentIndex = index
                        onDoubleClicked: {
                            updateCurrentDirectory(model.modelData.ActualPath)
                            bookmarkPanel.close()
                        }
                    }

                    PropertyAnimation{
                        id: mouseEnteredAnimation
                        target: bookmarkListDelegate
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: "#9dcfe2"
                        duration: 250
                    }
                    PropertyAnimation{
                        id: mouseExitedAnimation
                        target: bookmarkListDelegate
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: "transparent"
                        duration: 250
                    }
                }

                highlightFollowsCurrentItem: true
                highlight: Rectangle{
                    width: bookmarkList.width
                    height: 25
                    color: "skyblue"
                    opacity: 0.5
                }
                ScrollIndicator.vertical: ScrollIndicator{}
            }
        }
    }

    enter: Transition{
        NumberAnimation{
            property: "width"
            to: bookmarkPanel.widthWhenExpanded
            duration: 500
        }
    }

    exit: Transition{
        NumberAnimation{
            property: "width"
            to: 0
            duration: 500
        }
    }

    onOpened: rFileSystem.updateStoredBookmarkList()
}
