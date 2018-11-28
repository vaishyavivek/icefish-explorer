import QtQuick 2.7
import QtQuick.Controls 2.2

Popup{
    id: recentsPanel
    padding: 0
    property int widthWhenExpanded
    property bool isOpened: false

    clip: true
    closePolicy: Popup.NoAutoClose

    Rectangle{
        id: recentsPanelParentRect
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
                        text: "  Recents"
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
                    icon.name: "application-exit"
                    icon.color: mainWindow.fontColor
                    onClicked: {
                        isOpened = false
                        recentsPanel.close()
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
                id: recentsList
                width: parent.width
                height: parent.height - headerBar.height - 4
                model: rFileSystem.RecentsList

                delegate: Rectangle{
                    id: recentsListDelegate
                    width: recentsList.width
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
                                source: "image://mime" + model.modelData.ActualPath
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
                            icon.source: "/local/Resources/icons-close.svg"
                            icon.color: mainWindow.fontColor
                            onClicked: {
                                recentsListDelegate.visible = false
                                //rFileSystem.writeBookmarkAsync(model.modelData.ActualPath, false)
                            }
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        z: -1
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
                        onClicked: recentsList.currentIndex = index
                        onDoubleClicked: {
                            updateCurrentDirectory(model.modelData.ActualPath)
                            recentsPanel.close()
                        }
                    }

                    PropertyAnimation{
                        id: mouseEnteredAnimation
                        target: recentsListDelegate
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: "#9dcfe2"
                        duration: 250
                    }
                    PropertyAnimation{
                        id: mouseExitedAnimation
                        target: recentsListDelegate
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: "transparent"
                        duration: 250
                    }
                }

                highlightFollowsCurrentItem: true
                highlight: Rectangle{
                    width: recentsList.width
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
            to: recentsPanel.widthWhenExpanded
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

    onOpened: rFileSystem.prepareHistoryInfoList()
}
