import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "SidePanels"
import "CustomComponents"
import "Popups"

ApplicationWindow{
    id: mainWindow
    visible: true
    minimumWidth: 900
    minimumHeight: 600

    color: rFileSystem.BackgroundColor

    Row{
        anchors.fill: parent
        Rectangle{
            id: sideBar
            width: 35
            height: parent.height
            color: "transparent"
            SidePanel{}
        }

        Column{
            id: tabParentLayout
            readonly property int tabLimit: 8
            width: parent.width - sideBar.width
            height: parent.height

            Rectangle{
                id: tabHeaderParentRect
                width: parent.width
                height: 35
                color: "transparent"

                Rectangle{
                    anchors.fill: parent
                    opacity: 0.2
                    color: rFileSystem.HighlightColor
                }

                Row{
                    anchors.fill: parent
                    ListView{
                        id: tabHeader
                        property int perDelegateWidth: width/count
                        width: parent.width - addNewTabBtn.width
                        height: parent.height
                        model: rFileSystem.TabHeaderList
                        clip: true
                        orientation: ListView.Horizontal
                        layoutDirection: ListView.LeftToRight
                        highlightFollowsCurrentItem: true

                        delegate: Rectangle{
                            id: tabHeaderDelegate
                            width: tabHeader.perDelegateWidth
                            height: parent.height
                            color: (tabHeader.currentIndex == index) ? "transparent" : "lightgray"
                            opacity: (tabHeader.currentIndex == index) ? 1 : 0.4

                            Row{
                                anchors.fill: parent
                                Rectangle{
                                    id: materialButton
                                    width: parent.height
                                    height: parent.height
                                    color: "transparent"

                                    Image {
                                        source: "image://mime" + model.modelData.Path
                                        sourceSize.width: parent.width*0.75
                                        sourceSize.height: parent.height*0.75
                                        anchors.centerIn: parent
                                    }
                                }

                                Rectangle{
                                    width: parent.width - materialButton.width - closeBtn.width
                                    height: parent.height
                                    clip: true
                                    color: "transparent"
                                    Text {
                                        text: model.modelData.DisplayName
                                        font.pointSize: 12
                                        verticalAlignment: Text.AlignVCenter
                                        color: rFileSystem.IconColor
                                        width: parent.width
                                        height: parent.height
                                        clip: true
                                    }
                                }
                                RImageButton{
                                    id: closeBtn
                                    height: parent.height/2
                                    width: height
                                    anchors.verticalCenter: parent.verticalCenter
                                    icon.source: "/local/assets/icons-close.svg"
                                    icon.color: rFileSystem.IconColor
                                    hoverText: "Close"
                                    onClicked: deleteTab(index)
                                }
                            }

                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                z: -1
                                onEntered: mouseEnteredAnimation.start()
                                onExited: mouseExitedAnimation.start()
                                onClicked: {
                                    tabHeader.currentIndex = index
                                    mainTabControl.currentIndex = index
                                }
                            }

                            Rectangle{
                                id: animatingRect
                                anchors.fill: parent
                                opacity: 0.3
                                radius: height/2
                                color: "transparent"
                            }

                            PropertyAnimation{
                                id: mouseEnteredAnimation
                                target: animatingRect
                                property: "color"
                                to: rFileSystem.HighlightColor
                                duration: rFileSystem.GlobalAnimationDuration
                            }
                            PropertyAnimation{
                                id: mouseExitedAnimation
                                target: animatingRect
                                property: "color"
                                to: (tabHeader.currentIndex == index) ? "transparent" : "lightgray"
                                duration: rFileSystem.GlobalAnimationDuration
                            }
                        }


                        onCountChanged: {
                            if(count < tabParentLayout.tabLimit && !addNewTabBtn.visible){
                                addNewTabBtn.visible = true
                                addNewTabBtn.width = addNewTabBtn.height
                            }
                        }
                    }

                    RImageButton{
                        id: addNewTabBtn
                        height: parent.height
                        width: height
                        icon.source: "/local/assets/icons-add.svg"
                        icon.width: width/2
                        icon.height: height/2
                        icon.color: rFileSystem.IconColor
                        hoverText: "New Tab"
                        onClicked: {
                            if(tabHeader.count === tabParentLayout.tabLimit - 1){
                                addNewTabBtn.visible = false
                                addNewTabBtn.width = 0
                            }
                            rFileSystem.createNewTab()
                        }
                    }
                }
            }

            Rectangle{
                width: parent.width
                height: 1
                opacity: 0.2
                color: rFileSystem.IconColor
            }

            TabView{
                id: mainTabControl
                width: parent.width
                height: parent.height - tabHeaderParentRect.height - 1
                tabsVisible: false
                Component.onCompleted: rFileSystem.createNewTab()//createTab()
            }
        }
    }

    function createTab(){
        var tab = mainTabControl.addTab("", Qt.createComponent("TabViewDelegate.qml"))
        tab.active = true
        /*if(path === undefined)
            rFileSystem.createNewTab()
        else
            rFileSystem.createNewTab(path)*/
        tab.item.qtModel = rFileSystem.getTabData()
        mainTabControl.currentIndex = tabHeader.count - 1
        tabHeader.currentIndex = tabHeader.count - 1
    }

    function deleteTab(index){
        if(index !== 0)
            mainTabControl.currentIndex = index - 1
        else if(mainTabControl.count > 1)
            mainTabControl.currentIndex = index + 1
        else
            mainWindow.close()

        mainTabControl.removeTab(index)
        rFileSystem.deleteTab(index)
    }

    NotificationPanel{
        id: notificationPanel
        width: mainTabControl.width*0.9
        height: mainTabControl.height*0.1
        x: sidePanel.width + mainTabControl.width/2 - width/2
        oldY: mainWindow.height
        newY: mainWindow.height - height - 10
    }

    Connections{
        target: rFileSystem
        ignoreUnknownSignals: true
        onCreateQmlTab: createTab()
    }
}
