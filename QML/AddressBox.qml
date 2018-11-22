import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    id: addressBoxParentItem
    property string highlightColor: "lightblue"
    property bool currentView: true

    Loader{
        id: addressBoxLoader
        width: parent.width
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        asynchronous: true

        sourceComponent: listViewParentComp

        Component{
            id: textInputFieldParentComp
            TextField{
                id: textInputField
                width: addressBoxLoader.width
                height: addressBoxLoader.height
                focus: true
                placeholderText: "Enter address or make a search..."
                text: qtModel.AddressBoxData
                //background: mainWindow.color
                //color: mainWindow.fontColor

                onAccepted: {
                    qtModel.updateCurrentDirectory(text)
                    switchToListView()
                }
                Keys.onPressed: {
                    if(event.key === Qt.Key_Escape)
                        switchToListView()
                }
            }
        }

        Component{
            id: listViewParentComp
            ListView{
                id: listView
                width: 0
                height: addressBoxLoader.height
                clip: true
                model: qtModel.AddressBoxDataListView

                orientation: ListView.Horizontal
                layoutDirection: ListView.LeftToRight
                delegate: Rectangle{
                    id: listViewDelegate
                    color: "transparent"
                    width: 38
                    height: listView.height
                    Row{
                        anchors.fill: parent
                        anchors.rightMargin: 5
                        spacing: 3
                        Rectangle{
                            id: shortcutMenuBtn
                            width: 15
                            height: parent.height
                            color: "transparent"
                            Text {
                                id: shortcutMenuBtnImageText
                                text: "<"
                                font.bold: true
                                font.pointSize: 12
                                color: mainWindow.fontColor
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: mouseEnteredAnimationShortcutMenu.start()
                                onExited: mouseExitedAnimationShortcutMenu.start()
                                onClicked: {
                                    qtModel.updateAddressBoxShortcutMenuList(model.modelData.Path)
                                    var shortcutMenuPopupComp = Qt.createComponent("ShortcutMenu.qml")
                                    var shortcutMenuPopupObj = shortcutMenuPopupComp.createObject(shortcutMenuBtn, {"x": parent.x, "y": parent.height})
                                }
                            }
                            PropertyAnimation{
                                id: mouseEnteredAnimationShortcutMenu
                                target: shortcutMenuBtnImageText
                                property: "color"
                                to: "lightblue"
                                duration: 250
                            }
                            PropertyAnimation{
                                id: mouseExitedAnimationShortcutMenu
                                target: shortcutMenuBtnImageText
                                property: "color"
                                to: "black"
                                duration: 250
                            }

                        }
                        Rectangle{
                            id: nameParentRect
                            width: parent.width - 15
                            height: parent.height
                            color: "transparent"
                            Text {
                                id: name
                                text: model.modelData.DisplayName
                                font.pointSize: 10
                                font.family: "Sans Serif"
                                color: mainWindow.fontColor
                                anchors.centerIn: parent
                                Component.onCompleted: {
                                    listViewDelegate.width = name.paintedWidth + 25
                                    if(listView.width < addressBox.width)
                                        listView.width += listViewDelegate.width
                                    listView.contentWidth += listViewDelegate.width
                                }
                            }
                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: mouseEnteredAnimationName.start()
                                onExited: mouseExitedAnimationName.start()
                                onClicked: qtModel.updateCurrentDirectory(model.modelData.Path)
                            }

                            PropertyAnimation{
                                id: mouseEnteredAnimationName
                                target: nameParentRect
                                property: "color"
                                to: "lightblue"
                                duration: 250
                            }
                            PropertyAnimation{
                                id: mouseExitedAnimationName
                                target: nameParentRect
                                property: "color"
                                to: "transparent"
                                duration: 250
                            }
                        }
                    }
                }
                onModelChanged: contentWidth = 0
                onCountChanged: {
                    if(contentWidth > width)
                        contentX = contentWidth - width
                }
            }
        }
    }

    Connections{
        target: qtModel
        ignoreUnknownSignals: true
        onAskAddressBoxToSwitchToListViewMode: {
            currentView = newValue
            if(newValue)
                switchToListView()
            else
                switchToTextBox()
        }
    }

    function switchToListView(){
        addressBoxLoader.sourceComponent = listViewParentComp
        switchBetweenBtn.hoverText = "Imput Method: JumpList"
        currentView = true
    }

    function switchToTextView(){
        addressBoxLoader.sourceComponent = textInputFieldParentComp
        switchBetweenBtn.hoverText = "Imput Method: Text"
        currentView = false
    }

    RImageButton{
        id: switchBetweenBtn
        height: parent.height*0.75
        width: height
        anchors.right: parent.right
        anchors.rightMargin: parent.height*0.25
        anchors.verticalCenter: parent.verticalCenter
        iconPath: "/local/Resources/icons-search.svg"
        onClicked: {
            if(!addressBox.currentView)
                addressBox.switchToListView()
            else
                addressBox.switchToTextView()
        }
    }
}
