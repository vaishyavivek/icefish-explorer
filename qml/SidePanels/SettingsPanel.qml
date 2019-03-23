import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../CustomComponents"

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
        anchors.centerIn: parent
        color: rFileSystem.BackgroundColor

        Rectangle{
            anchors.fill: parent
            opacity: 0.2
            color: rFileSystem.HighlightColor
        }

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
                    icon.source: "/local/assets/popup-close.svg"
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

            ScrollView{
                width: parent.width - 8
                height: parent.height - headerBar.height - 5
                anchors.horizontalCenter: parent.horizontalCenter
                contentWidth: width
                contentHeight: 650
                clip: true

                Rectangle{
                    width: parent.width
                    height: 650
                    color: "transparent"
                    Column{
                        anchors.fill: parent

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
                                property var iconColorList: ["black", "white", "darkred", "darkslateblue", "deeppink", "antiquewhite"]
                                property var backgroundColorList: ["white", "#312d2d", "cornsilk", "azure", "pink", "cornflowerblue"]
                                property var highlightColorList: ["silver", "lightgray", "moccasin", "paleturquoise", "mistyrose", "slateblue"]
                                property var selectionColorList: ["grey", "darkgray", "goldenrod", "aqua", "mistyrose", "slateblue"]

                                width: parent.width*0.5
                                height: 30
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.bottom: parent.bottom
                                model: ["Light", "Dark", "Cream", "Aqua", "Rose", "Corn Flower"]
                                currentIndex: rFileSystem.AppTheme
                                onCurrentTextChanged: {
                                    rFileSystem.AppTheme = currentIndex
                                    rFileSystem.IconColor = iconColorList[currentIndex]
                                    rFileSystem.BackgroundColor = backgroundColorList[currentIndex]
                                    rFileSystem.HighlightColor = highlightColorList[currentIndex]
                                    rFileSystem.SelectedColor = selectionColorList[currentIndex]
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

                                handle: Rectangle {
                                    x: animationDurationSlider.leftPadding + animationDurationSlider.visualPosition * (animationDurationSlider.availableWidth - width)
                                    y: animationDurationSlider.topPadding + animationDurationSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    radius: 8
                                    color: animationDurationSlider.pressed ? rFileSystem.SelectedColor : rFileSystem.HighlightColor
                                    border.color: rFileSystem.IconColor
                                }

                                from: 50
                                to: 2000
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
                            id: fileFolderView
                            width: parent.width
                            height: 50
                            color: "transparent"
                            Text {
                                text: qsTr("Display Style")
                                font.pointSize: 10
                                anchors.left: parent.left
                                color: rFileSystem.IconColor
                                anchors.leftMargin: 10
                            }
                            RComboBox{
                                id: fileFolderViewCb
                                width: parent.width*0.5
                                height: 30
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.bottom: parent.bottom
                                model: ["Default", "ListView", "GridView"]
                                currentIndex: rFileSystem.GlobalFileFolderView
                                onCurrentIndexChanged: rFileSystem.GlobalFileFolderView = currentIndex
                            }
                        }
                        Rectangle{
                            height: 2
                            width: parent.width
                            color: "lightgrey"
                            opacity: 0.5
                        }

                        Rectangle{
                            id: cloudAccounts
                            width: parent.width
                            height: 50
                            color: "transparent"
                            Text {
                                text: qsTr("Manage Cloud Accounts")
                                font.pointSize: 10
                                anchors.left: parent.left
                                color: rFileSystem.IconColor
                                anchors.leftMargin: 10
                            }
                        }

                        Rectangle{
                            height: 2
                            width: parent.width
                            color: "lightgrey"
                            opacity: 0.5
                        }

                        Rectangle{
                            id: aboutsUs
                            width: parent.width
                            height: 300
                            color: "transparent"
                            Column{
                                anchors.fill: parent
                                spacing: 5
                                Image {
                                    source: "/local/assets/explorer-icefish.png"
                                    sourceSize.width: parent.width*0.4
                                    sourceSize.height: parent.width*0.4
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                Text {
                                    text: qsTr("IceFish Explorer")
                                    font.pointSize: 16
                                    color: rFileSystem.IconColor
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                Text {
                                    text: qsTr("Version 1.2")
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                Image {
                                    id: companyLogo
                                    source: "/local/assets/company-logo.png"
                                    sourceSize.width: parent.width*0.5
                                    sourceSize.height: parent.width*0.5
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    ColorOverlay{
                                        anchors.fill: companyLogo
                                        source: companyLogo
                                        color: rFileSystem.IconColor
                                    }
                                }

                                Text {
                                    text: qsTr("Qt Version: 5.12\n Qml Version: 2")
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    enter: Transition{
        NumberAnimation{
            property: "width"
            to: settingsPanel.widthWhenExpanded
            duration: rFileSystem.GlobalAnimationDuration*2
        }
    }

    exit: Transition{
        NumberAnimation{
            property: "width"
            to: 0
            duration: rFileSystem.GlobalAnimationDuration*2
        }
    }
}
