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

import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2
import "SidePanels"
import "CustomComponents"
import "Popups"

ApplicationWindow{
    id: mainWindow
    visible: true
    minimumWidth: 900
    minimumHeight: 600

    flags: Qt.FramelessWindowHint
    x: Screen.desktopAvailableWidth*0.5 - width*0.5
    y: Screen.desktopAvailableHeight*0.5 - height*0.5

    color: "transparent"//rFileSystem.BackgroundColor1

    Row{
        anchors.fill: parent
        Rectangle{
            id: sideBar
            width: 45
            height: parent.height
            color: "transparent"
            SidePanel{ id: sidePanel}
        }

        Column{
            width: parent.width - sideBar.width
            height: parent.height

            Rectangle{
                id: tabHeaderParentRect
                width: parent.width
                height: 45
                color: "transparent"

                Rectangle{
                    id: bgColor
                    anchors.fill: parent
                    color: Qt.darker(rFileSystem.BackgroundColor2)
                    opacity: 0.5
                }


                Row{
                    anchors.fill: parent
                    anchors.bottomMargin: 1
                    spacing: 5

                    Rectangle{
                        width: parent.width - windowControlBar.width
                        height: parent.height
                        color: "transparent"

                        Row{
                            anchors.fill: parent

                            ListView{
                                id: tabHeader
                                property int perDelegateWidth: width/count
                                width: parent.width - addNewTabBtn.width
                                height: parent.height*0.8
                                anchors.verticalCenter: parent.verticalCenter
                                model: rFileSystem.TabHeaderList
                                clip: true
                                orientation: ListView.Horizontal
                                layoutDirection: ListView.LeftToRight
                                highlightFollowsCurrentItem: true

                                delegate: Rectangle{
                                    id: tabHeaderDelegate
                                    width: tabHeader.perDelegateWidth
                                    height: parent.height
                                    color: "transparent"
                                    opacity: (tabHeader.currentIndex == index) ? 1 : 0.25

                                    Row{
                                        anchors.fill: parent
                                        Rectangle{
                                            id: materialButton
                                            width: parent.height
                                            height: parent.height
                                            color: "transparent"

                                            Image {
                                                source: "image://xdg/" + model.modelData.FileType
                                                sourceSize.width: parent.width*0.75
                                                sourceSize.height: parent.height*0.75
                                                anchors.centerIn: parent
                                                asynchronous: true
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
                                                color: rFileSystem.IconColor2
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
                                            icon.source: "/local/assets/close.svg"
                                            icon.color: rFileSystem.IconColor2
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
                                            sidePanel.radioGroup.checked = Qt.Unchecked
                                        }
                                    }

                                    Rectangle{
                                        id: animatingRect
                                        anchors.fill: parent
                                        opacity: 0.25
                                        radius: 5
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
                                        to: "transparent"
                                        duration: rFileSystem.GlobalAnimationDuration
                                    }
                                }


                                onCountChanged: {
                                    if(count < mainTabControl.tabLimit && !addNewTabBtn.visible){
                                        addNewTabBtn.visible = true
                                        addNewTabBtn.width = addNewTabBtn.height
                                    }
                                }
                            }

                            RImageButton{
                                id: addNewTabBtn
                                height: parent.height*0.8
                                width: height
                                anchors.verticalCenter: parent.verticalCenter
                                icon.source: "/local/assets/add.svg"
                                icon.width: width/2
                                icon.height: height/2
                                icon.color: rFileSystem.IconColor2
                                hoverText: "New Tab"
                                onClicked: {
                                    if(tabHeader.count === mainTabControl.tabLimit - 1){
                                        addNewTabBtn.visible = false
                                        addNewTabBtn.width = 0
                                    }
                                    rFileSystem.createNewTab()
                                }
                            }
                        }
                    }

                    RWindowControlBar{
                        id: windowControlBar
                    }
                }

                Rectangle{
                    id: separator
                    color: rFileSystem.BackgroundColor2
                    opacity: 0.1
                    height: 1
                    width: parent.width
                    anchors.bottom: parent.bottom
                }
            }

            TabView{
                id: mainTabControl
                property int tabLimit: 8
                width: parent.width
                height: parent.height - tabHeaderParentRect.height - 1
                tabsVisible: false
                Component.onCompleted: {
                    rFileSystem.createNewTab("startpage")
                    var tab = mainTabControl.addTab("", Qt.createComponent("StartPage.qml"))
                    tab.active = true
                }
            }
        }


    }

    MouseArea{
        id: mouseArea
        z: -5
        anchors.fill: parent
        onPressAndHold: {
            console.log(mouse.x, mouse.y)
        }
    }

    Drag.active: mouseArea.drag.active

    function createTab(tabName){
        var tab = undefined
        if(tabName === "")
            tab = mainTabControl.addTab("", Qt.createComponent("TabViewDelegate.qml"))
        else
            tab = mainTabControl.addTab("", Qt.createComponent(tabName))
        tab.active = true

        if(tabName === "")
            tab.item.qtModel = rFileSystem.getTabData()
        //console.log(tab.item.qtModel)
        mainTabControl.currentIndex = tabHeader.count - 1
        tabHeader.currentIndex = tabHeader.count - 1
    }

    function deleteTab(index){
        if(index !== 0)
            mainTabControl.currentIndex = index - 1
        else if(mainTabControl.count > 1)
            mainTabControl.currentIndex = index + 1
        else
            Qt.quit()

        mainTabControl.removeTab(index)
        rFileSystem.deleteTab(index)
    }

    NotificationPanel{
        id: notificationPanel
        width: mainTabControl.width*0.9
        height: mainTabControl.height*0.1
        x: sideBar.width + mainTabControl.width/2 - width/2
        oldY: mainWindow.height
        newY: mainWindow.height - height - 10
    }

    Connections{
        target: rFileSystem
        ignoreUnknownSignals: true
        onCppTabListChanged: createTab(stdName)
    }

}
