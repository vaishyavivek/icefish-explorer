import QtQuick 2.7
import QtQuick.Controls 2.2

ToolTip{
    id: rmenu
    property bool isOpened: false
    property string filePath
    property variant menuList
    padding: 2

    ListView{
        id: menuListView
        anchors.fill: parent
        clip: true
        model: menuList

        delegate: Rectangle{
            id: menuListDelegate
            width: menuListView.width
            height: 25
            color: rFileSystem.BackgroundColor
            Loader{
                anchors.centerIn: parent
                width: parent.width - 2
                height: parent.height - 2
                sourceComponent: model.modelData.HasSubmenu ? submenu : menuItem
            }

            Component{
                id: menuItem
                Rectangle{
                    width: menuListDelegate.width
                    height: menuListDelegate.height
                    color: "transparent"
                    Text {
                        width: parent.width
                        height: parent.height
                        text: "      " + model.modelData.ServiceName
                        color: rFileSystem.IconColor
                        font.family: "Sans Serif"
                        font.pointSize: Math.max(scaleFactor*0.16, 8)
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
                        onClicked: {
                            var action = model.modelData.Action
                            if(action === "newtab")
                                rFileSystem.createNewTab(filePath)
                            else
                                qtModel.performAction(filePath, action)
                            rmenu.close()
                        }
                    }
                }
            }

            Component{
                id: submenu
                Rectangle{
                    width: menuListDelegate.width
                    height: menuListDelegate.height
                    color: "transparent"

                    Text {
                        id: displayText
                        width: parent.width
                        height: parent.height
                        text: "<    " + model.modelData.ServiceName
                        color: rFileSystem.IconColor
                        font.family: "Sans Serif"
                        font.pointSize: Math.max(scaleFactor*0.16, 8)
                        verticalAlignment: Text.AlignVCenter
                    }
                    ToolTip{
                        id: submenuPopup
                        property bool isOpened: false
                        property string action: model.modelData.Action
                        property variant subMenuModel: model.modelData.Submenu
                        padding: 2
                        width: 200
                        height: (model.modelData.SubmenuCount)*25 + 2
                        x: parent.x - 202
                        y: parent.y
                        ListView{
                            id: submenuListView
                            anchors.fill: parent
                            clip: true
                            model: submenuPopup.subMenuModel

                            delegate: Rectangle{
                                id: submenuListDelegate
                                width: submenuListView.width
                                height: 25
                                color: rFileSystem.BackgroundColor

                                Row{
                                    anchors.fill: parent
                                    spacing: 5
                                    Image {
                                        id: image
                                        width: parent.height
                                        height: parent.height
                                        source: model.modelData.ServiceIcon
                                        sourceSize.height: parent.height
                                        sourceSize.width: parent.height
                                    }
                                    Text {
                                        width: parent.width - image.width
                                        height: parent.height
                                        text: model.modelData.ServiceName
                                        color: rFileSystem.IconColor
                                        font.family: "Sans Serif"
                                        font.pointSize: Math.max(scaleFactor*0.16, 8)
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: submouseEnteredAnimation.start()
                                    onExited: submouseExitedAnimation.start()
                                    onClicked: {
                                        qtModel.performAction(filePath, submenuPopup.action, model.modelData.DesktopFile)
                                        submenuPopup.close()
                                    }
                                }

                                PropertyAnimation{
                                    id: submouseEnteredAnimation
                                    target: submenuListDelegate
                                    property: "color"
                                    easing.type: Easing.OutInQuad
                                    to: rFileSystem.HighlightColor
                                    duration: 100
                                }
                                PropertyAnimation{
                                    id: submouseExitedAnimation
                                    target: submenuListDelegate
                                    property: "color"
                                    easing.type: Easing.OutInQuad
                                    to: rFileSystem.BackgroundColor
                                    duration: 100
                                }
                            }
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
                        onClicked: submenuPopup.open()
                    }
                }
            }

            PropertyAnimation{
                id: mouseEnteredAnimation
                target: menuListDelegate
                property: "color"
                easing.type: Easing.OutInQuad
                to: rFileSystem.HighlightColor
                duration: 100
            }
            PropertyAnimation{
                id: mouseExitedAnimation
                target: menuListDelegate
                property: "color"
                easing.type: Easing.OutInQuad
                to: rFileSystem.BackgroundColor
                duration: 100
            }
        }
    }
    onClosed: isOpened = false
}
