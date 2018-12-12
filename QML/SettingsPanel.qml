import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4

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
                height: 2
                width: parent.width
                color: "grey"
                opacity: 0.5
            }

            Rectangle{
                id: headerBar
                width: parent.width
                height: 35
                color: "transparent"
                Rectangle{
                    id: titleRect
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    height: parent.height
                    width: parent.width - closeSBtn.width
                    color: "transparent"
                    Text {
                        width: parent.width
                        height: parent.height
                        text: "GLOBAL SETTINGS"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 12
                        color: rFileSystem.IconColor
                    }
                }
                RImageButton{
                    id: closeSBtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    icon.name: "application-exit"//"/local/Resources/icons-close.svg"
                    icon.color: rFileSystem.IconColor
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
                    color: rFileSystem.IconColor
                    anchors.leftMargin: 10
                }
                RComboBox{
                    id: themeCb
                    property var iconColorList: ["black", "white", "darkred", "darkslateblue", "fuchsia", "antiquewhite"]
                    property var backgroundColorList: ["white", "#312d2d", "cornsilk", "azure", "lightpink", "cornflowerblue"]
                    property var highlightColorList: ["powderblue", "darkgray", "goldenrod", "lightblue", "mistyrose", "slateblue"]

                    width: parent.width*0.5
                    height: 30
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.bottom: parent.bottom
                    model: ["Light", "Dark", "Cream", "Marine", "Fuchsia", "Corn Flower"]
                    currentIndex: rFileSystem.AppTheme
                    onCurrentTextChanged: {
                        rFileSystem.AppTheme = currentIndex
                        rFileSystem.IconColor = iconColorList[currentIndex]
                        rFileSystem.BackgroundColor = backgroundColorList[currentIndex]
                        rFileSystem.HighlightColor = highlightColorList[currentIndex]
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
                    color: rFileSystem.IconColor
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
                    color: rFileSystem.IconColor
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
                    currentIndex: rFileSystem.GlobalIsPreviewAvailable
                    onCurrentIndexChanged: rFileSystem.GlobalIsPreviewAvailable = currentIndex
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
                    color: rFileSystem.IconColor
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

            Rectangle{
                id: iconScale
                width: parent.width
                height: 50
                color: "transparent"
                Text {
                    text: qsTr("Icon Scaling")
                    font.pointSize: 10
                    anchors.left: parent.left
                    color: rFileSystem.IconColor
                    anchors.leftMargin: 10
                }
                RComboBox{
                    id: iconScaleCb
                    width: parent.width*0.5
                    height: 30
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.bottom: parent.bottom
                    model: ["Tiny", "Small (Default)", "Medium", "Big", "Large"]
                    currentIndex: rFileSystem.GlobalIconScale
                    onCurrentIndexChanged: rFileSystem.GlobalIconScale = currentIndex
                }
            }
            Rectangle{
                height: 2
                width: parent.width
                color: "lightgrey"
                opacity: 0.5
            }

            Rectangle{
                id: animationDuration
                width: parent.width
                height: 50
                color: "transparent"
                Text {
                    text: qsTr("Animation Duration")
                    font.pointSize: 10
                    anchors.left: parent.left
                    color: rFileSystem.IconColor
                    anchors.leftMargin: 10
                }
                Slider{
                    id: animationDurationSlider
                    width: parent.width*0.5
                    height: 30
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.bottom: parent.bottom
                    minimumValue: 50
                    maximumValue: 2000
                    stepSize: 50
                    value: rFileSystem.GlobalAnimationDuration
                    onValueChanged: rFileSystem.GlobalAnimationDuration = value
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
