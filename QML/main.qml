import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ApplicationWindow{
    id: mainWindow
    visible: true
    minimumWidth: 900
    minimumHeight: 600

    property bool appTheme: (rDesktopService.getSettingsValue("Theme") === "Light")
    property string fontColor: (appTheme ? "black" : "white")
    property string backgroundColor: (appTheme ? "white" : "#312d2d")

    color: (appTheme ? "white" : "#312d2d")

    Row{
        anchors.fill: parent
        Rectangle{
            id: sideBar
            width: 35
            height: parent.height
            color: "transparent"
            SidePanel{
                id: sidePanel
                normalizedWidth: Math.min(35, mainWindow.width*0.05)
                widthWhenExpanded: Math.min(200, mainWindow.width*0.25)
            }
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
                color: mainWindow.color
                Row{
                    anchors.fill: parent
                    ListView{
                        id: tabHeader
                        property int perDelegateWidth: width/rFileSystem.TabHeaderListCount
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
                            color: (tabHeader.currentIndex == index) ? "transparent" : "lightgrey"
                            opacity: (tabHeader.currentIndex == index) ? 1 : 0.4

                            Row{
                                anchors.fill: parent
                                Rectangle{
                                    id: materialButton
                                    width: parent.height
                                    height: parent.height
                                    color: "transparent"

                                    Image {
                                        source: model.modelData.IconPath
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
                                        color: fontColor
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
                                    iconPath: "file:///home/eobardthawne/.icons/Papirus/32/emblems/emblem-noread.svg"
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

                            PropertyAnimation{
                                id: mouseEnteredAnimation
                                target: tabHeaderDelegate
                                property: "color"
                                to: "lightblue"
                                duration: 500
                            }
                            PropertyAnimation{
                                id: mouseExitedAnimation
                                target: tabHeaderDelegate
                                property: "color"
                                to: "transparent"
                                duration: 500
                            }
                        }
                    }

                    RImageButton{
                        id: addNewTabBtn
                        height: parent.height
                        width: height
                        iconPath: "file:///home/eobardthawne/.icons/Papirus/32/emblems/emblem-new.svg"
                        hoverText: "New Tab"
                        onClicked: {
                            if(rFileSystem.TabHeaderListCount === tabParentLayout.tabLimit - 1){
                                addNewTabBtn.visible = false
                                addNewTabBtn.width = 0
                            }
                            createTab()
                        }
                    }
                }
            }

            Rectangle{
                width: parent.width
                height: 1
                opacity: 0.2
                color: "black"
            }

            TabView{
                id: mainTabControl
                width: parent.width
                height: parent.height - tabHeaderParentRect.height - 1
                tabsVisible: false
                Component.onCompleted: createTab()
                onCurrentIndexChanged: forceActiveFocus()
            }
        }
    }

    function createTab(){
        var tab = mainTabControl.addTab("", Qt.createComponent("TabViewDelegate.qml"))
        tab.active = true
        rFileSystem.createNewTab()
        tab.item.qtModel = rFileSystem.getTabData()
        mainTabControl.currentIndex = rFileSystem.TabHeaderListCount - 1
        tabHeader.currentIndex = rFileSystem.TabHeaderListCount - 1
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
        background: mainWindow.color
    }
}