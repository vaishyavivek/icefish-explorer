import QtQuick 2.7
import QtQuick.Controls 2.2

Popup{
    id: rmenu
    property bool isOpened: false
    property variant menuList
    padding: 0

    ListView{
        id: menuListView
        anchors.fill: parent
        anchors.margins: 1
        clip: true
        model: menuList
        spacing: 1

        delegate: Rectangle{
            id: menuListDelegate
            width: menuListView.width
            height: 25
            color: "transparent"
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
                        text: "      " + model.modelData.DisplayText
                        font.family: "Sans Serif"
                        font.pointSize: Math.max(scaleFactor*0.16, 8)
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
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
                        width: parent.width
                        height: parent.height
                        text: "<    " + model.modelData.DisplayText
                        font.family: "Sans Serif"
                        font.pointSize: Math.max(scaleFactor*0.16, 8)
                        verticalAlignment: Text.AlignVCenter
                    }
                    Popup{
                        id: submenuPopup
                        property bool isOpened: false
                        property variant subMenuModel: model.modelData.Submenu
                        width: 200
                        height: (model.modelData.SubmenuCount)*26
                        x: parent.x - 202
                        padding: 0
                        ListView{
                            id: submenuListView
                            anchors.fill: parent
                            anchors.margins: 1
                            clip: true
                            model: submenuPopup.subMenuModel
                            spacing: 1

                            delegate: Rectangle{
                                id: submenuListDelegate
                                width: submenuListView.width
                                height: 25
                                color: "transparent"

                                Row{
                                    anchors.fill: parent
                                    spacing: 5
                                    Image {
                                        id: image
                                        width: parent.height
                                        height: parent.height
                                        //source: "file://" + model.modelData.IconPath
                                        sourceSize.height: parent.height
                                        sourceSize.width: parent.height
                                    }
                                    Text {
                                        width: parent.width - image.width
                                        height: parent.height
                                        text: model.modelData.DisplayText
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
                                }

                                PropertyAnimation{
                                    id: submouseEnteredAnimation
                                    target: submenuListDelegate
                                    property: "color"
                                    easing.type: Easing.OutInQuad
                                    to: "#9dcfe2"
                                    duration: 250
                                }
                                PropertyAnimation{
                                    id: submouseExitedAnimation
                                    target: submenuListDelegate
                                    property: "color"
                                    easing.type: Easing.OutInQuad
                                    to: "transparent"
                                    duration: 250
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

            /*MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: mouseEnteredAnimation.start()
                onExited: mouseExitedAnimation.start()
            }*/

            PropertyAnimation{
                id: mouseEnteredAnimation
                target: menuListDelegate
                property: "color"
                easing.type: Easing.OutInQuad
                to: "#9dcfe2"
                duration: 250
            }
            PropertyAnimation{
                id: mouseExitedAnimation
                target: menuListDelegate
                property: "color"
                easing.type: Easing.OutInQuad
                to: "transparent"
                duration: 250
            }
        }
    }
}