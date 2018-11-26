import QtQuick 2.7
import QtQuick.Controls 2.2

Popup{
    id: settingsPanel
    padding: 0
    property int widthWhenExpanded
    property bool isOpened: false

    clip: true
    closePolicy: Popup.NoAutoClose

    Rectangle{
        id: settingsPanelParentRect
        width: parent.width - 2
        height: parent.height - 2
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
                    width: parent.width - closeSBtn.width
                    anchors.leftMargin: 5
                    Text {
                        text: "  Global Settings"
                        font.bold: true
                        color: mainWindow.fontColor
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: 12
                    }
                }
                RImageButton{
                    id: closeSbtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    icon.name: "application-exit"//"/local/Resources/icons-close.svg"
                    icon.color: mainWindow.fontColor
                    onClicked: {
                        isOpened = false
                        settingsPanel.close()
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

            Rectangle{
                id: theme
                width: parent.width
                height: 50
                color: "transparent"
                Text {
                    text: qsTr("Application Theme")
                    font.pointSize: 10
                    anchors.left: parent.left
                    color: mainWindow.fontColor
                    anchors.leftMargin: 10
                }
                RComboBox{
                    id: themeCb
                    width: parent.width*0.5
                    height: 30
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.bottom: parent.bottom
                    model: ["Light", "Dark"]
                    currentIndex: ((rDesktopService.getSettingsValue("Theme") === "Light") ? 0 : 1)
                    onCurrentTextChanged: {
                        rDesktopService.applySettingsValue("Theme", currentText)
                        mainWindow.color = (currentText === "Light") ? "white" : "#312d2d"
                        mainWindow.fontColor = (currentText === "Light") ? "black" : "white"
                    }
                }
            }
            Rectangle{
                height: 2
                width: parent.width
                color: "lightgrey"
                opacity: 0.5
            }

            Rectangle{
                id: rectangle
                width: parent.width
                height: 30
                color: "transparent"
                Text {
                    text: "Keep these values to default to allow each directory \nto have its seperate settings."
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    anchors.verticalCenterOffset: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle{
                height: 2
                width: parent.width
                color: "lightgrey"
                opacity: 0.5
            }

            Rectangle{
                id: imagePreview
                width: parent.width
                height: 50
                color: "transparent"
                Text {
                    text: qsTr("Image Preview")
                    font.pointSize: 10
                    anchors.left: parent.left
                    color: mainWindow.fontColor
                    anchors.leftMargin: 10
                }
                RComboBox{
                    id: imagePreviewCb
                    width: parent.width*0.5
                    height: 30
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.bottom: parent.bottom
                    model: ["Default", "Enable", "Disble"]
                    currentIndex: rDesktopService.getSettingsValue("PreviewAvailable")
                    onCurrentIndexChanged: rDesktopService.applySettingsValue("PreviewAvailable", currentIndex)
                }
            }
            Rectangle{
                height: 2
                width: parent.width
                color: "lightgrey"
                opacity: 0.5
            }

            Rectangle{
                id: hiddenItems
                width: parent.width
                height: 50
                color: "transparent"
                Text {
                    text: qsTr("Show Hidden Items")
                    font.pointSize: 10
                    anchors.left: parent.left
                    color: mainWindow.fontColor
                    anchors.leftMargin: 10
                }
                RComboBox{
                    id: hiddenItemsCb
                    width: parent.width*0.5
                    height: 30
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.bottom: parent.bottom
                    model: ["Default", "Allow", "Don't Allow"]
                    currentIndex: rFileSystem.GlobalIsHiddenItemsShown
                    onCurrentIndexChanged: rFileSystem.GlobalIsHiddenItemsShown = currentIndex
                }
            }
            Rectangle{
                height: 2
                width: parent.width
                color: "lightgrey"
                opacity: 0.5
            }
        }
    }

    enter: Transition{
        NumberAnimation{
            property: "width"
            to: settingsPanel.widthWhenExpanded
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
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
