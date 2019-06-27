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
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../CustomComponents"
import "../Popups"

ToolTip{
    id: settingsPanel
    padding: 0
    property int widthWhenExpanded
    property bool isOpened: false

    clip: true
    closePolicy: Popup.NoAutoClose
    contentWidth: widthWhenExpanded

    background: Rectangle{
        id: bgRect
        color: rFileSystem.BackgroundColor1
        border.color: rFileSystem.IconColor1
        border.width: 1
        radius: 5
        width: parent.width
        height: parent.height

        RectangularGlow{
            id: effect
            z: -1
            anchors.fill: parent
            glowRadius: 5
            spread: 0.5
            color: rFileSystem.BackgroundColor2
            cornerRadius: parent.radius + glowRadius
        }
    }

    Rectangle{
        id: content
        width: parent.width
        height: parent.height
        color: "transparent"
        visible: isOpened

        Column{
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent
            spacing: 5

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
                        color: rFileSystem.IconColor1
                    }
                }
                RImageButton{
                    id: closeSBtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    icon.source: "/local/assets/popup-close.svg"
                    icon.color: rFileSystem.IconColor1
                    onClicked: {
                        isOpened = false
                        settingsPanel.close()
                    }
                }
            }

            Rectangle{
                color: rFileSystem.BackgroundColor2
                opacity: 0.1
                height: 2
                width: parent.width - 10
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ScrollView{
                width: parent.width - 8
                height: parent.height - headerBar.height - 15
                anchors.horizontalCenter: parent.horizontalCenter
                contentWidth: width
                contentHeight: 900
                clip: true

                Rectangle{
                    width: parent.width
                    height: 650
                    color: "transparent"
                    Column{
                        anchors.fill: parent
                        spacing: 10

                        Rectangle{
                            id: theme
                            width: parent.width
                            height: 50
                            color: "transparent"
                            Column{
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                spacing: 10

                                Text {
                                    text: qsTr("Application Theme")
                                    verticalAlignment: Text.AlignVCenter
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor1
                                    height: 10
                                }

                                RComboBox{
                                    id: themeCb
                                    property var iconColorList1: ["#000000", "#000000", "#FFFFFF", "darkred", "darkslateblue", "deeppink", "antiquewhite", "#272B28"]
                                    property var iconColorList2: ["#FFFFFF", "grey", "white", "darkred", "darkslateblue", "deeppink", "antiquewhite", "#272B28"]
                                    property var backgroundColorList1: ["#FFFFFF", "#FFFFFF", "#312d2d", "cornsilk", "azure", "pink", "cornflowerblue", "#09789e"]
                                    property var backgroundColorList2: ["grey", "#000000", "#FFFFFF", "cornsilk", "azure", "pink", "cornflowerblue", "#E8E7E1"]
                                    property var highlightColorList: ["#1E90FF", "silver", "lightgray", "moccasin", "paleturquoise", "mistyrose", "slateblue", "#086786"]
                                    property var selectionColorList: ["#1E90FF", "grey", "darkgray", "goldenrod", "aqua", "mistyrose", "slateblue", "#1e96dc"]

                                    width: parent.width*0.5
                                    height: 30
                                    model: ["Style8", "Light", "Dark", "Cream", "Aqua", "Rose", "Corn Flower", "Chocolate"]
                                    currentIndex: rFileSystem.AppTheme
                                    onCurrentTextChanged: {
                                        rFileSystem.AppTheme = currentIndex
                                        rFileSystem.IconColor1 = iconColorList1[currentIndex]
                                        rFileSystem.IconColor2 = iconColorList2[currentIndex]
                                        rFileSystem.BackgroundColor1 = backgroundColorList1[currentIndex]
                                        rFileSystem.BackgroundColor2 = backgroundColorList2[currentIndex]
                                        rFileSystem.HighlightColor = highlightColorList[currentIndex]
                                        rFileSystem.SelectedColor = selectionColorList[currentIndex]
                                    }
                                }
                            }
                        }

                        Rectangle{
                            color: rFileSystem.BackgroundColor2
                            opacity: 0.1
                            height: 1
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle{
                            id: animationDuration
                            width: parent.width
                            height: 50
                            color: "transparent"
                            Column{
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                spacing: 10

                                Text {
                                    text: qsTr("Animation Duration")
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor1
                                    height: 10
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Slider{
                                    id: animationDurationSlider
                                    width: parent.width*0.5
                                    height: 30

                                    handle: Rectangle {
                                        x: animationDurationSlider.leftPadding + animationDurationSlider.visualPosition * (animationDurationSlider.availableWidth - width)
                                        y: animationDurationSlider.topPadding + animationDurationSlider.availableHeight / 2 - height / 2
                                        implicitWidth: 16
                                        implicitHeight: 16
                                        radius: 8
                                        color: animationDurationSlider.pressed ? rFileSystem.SelectedColor : rFileSystem.HighlightColor
                                        border.color: rFileSystem.IconColor1
                                    }

                                    from: 50
                                    to: 2000
                                    stepSize: 50
                                    value: rFileSystem.GlobalAnimationDuration
                                    onValueChanged: rFileSystem.GlobalAnimationDuration = value
                                }
                            }
                        }

                        Rectangle{
                            color: rFileSystem.BackgroundColor2
                            opacity: 0.1
                            height: 1
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle{
                            id: rectangle
                            width: parent.width
                            height: 30
                            color: "transparent"
                            Text {
                                text: "Keep these values to default to allow each directory \nto have its seperate settings."
                                verticalAlignment: Text.AlignVCenter
                                color: rFileSystem.IconColor1
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                anchors.verticalCenterOffset: 0
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Rectangle{
                            color: rFileSystem.BackgroundColor2
                            opacity: 0.1
                            height: 1
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle{
                            id: imagePreview
                            width: parent.width
                            height: 50
                            color: "transparent"

                            Column{
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                spacing: 10

                                Text {
                                    text: qsTr("Image Preview")
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor1
                                    height: 10
                                    verticalAlignment: Text.AlignVCenter
                                }
                                RComboBox{
                                    id: imagePreviewCb
                                    width: parent.width*0.5
                                    height: 30
                                    model: ["Default", "Enable", "Disble"]
                                    currentIndex: rFileSystem.GlobalIsPreviewAvailable
                                    onCurrentIndexChanged: rFileSystem.GlobalIsPreviewAvailable = currentIndex
                                }
                            }
                        }

                        Rectangle{
                            color: rFileSystem.BackgroundColor2
                            opacity: 0.1
                            height: 1
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle{
                            id: hiddenItems
                            width: parent.width
                            height: 50
                            color: "transparent"

                            Column{
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                spacing: 10

                                Text {
                                    text: qsTr("Show Hidden Items")
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor1
                                    height: 10
                                    verticalAlignment: Text.AlignVCenter
                                }
                                RComboBox{
                                    id: hiddenItemsCb
                                    width: parent.width*0.5
                                    height: 30
                                    model: ["Default", "Allow", "Don't Allow"]
                                    currentIndex: rFileSystem.GlobalIsHiddenItemsShown
                                    onCurrentIndexChanged: rFileSystem.GlobalIsHiddenItemsShown = currentIndex
                                }
                            }
                        }

                        Rectangle{
                            color: rFileSystem.BackgroundColor2
                            opacity: 0.1
                            height: 1
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle{
                            id: iconScale
                            width: parent.width
                            height: 50
                            color: "transparent"

                            Column{
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                spacing: 10

                                Text {
                                    text: qsTr("Icon Scaling")
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor1
                                    height: 10
                                    verticalAlignment: Text.AlignVCenter
                                }
                                RComboBox{
                                    id: iconScaleCb
                                    width: parent.width*0.5
                                    height: 30
                                    model: ["Tiny", "Small (Default)", "Medium", "Big", "Large"]
                                    currentIndex: rFileSystem.GlobalIconScale
                                    onCurrentIndexChanged: rFileSystem.GlobalIconScale = currentIndex
                                }
                            }
                        }

                        Rectangle{
                            color: rFileSystem.BackgroundColor2
                            opacity: 0.1
                            height: 1
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle{
                            id: fileFolderView
                            width: parent.width
                            height: 50
                            color: "transparent"

                            Column{
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                spacing: 10

                                Text {
                                    text: qsTr("Display Style")
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor1
                                    height: 10
                                    verticalAlignment: Text.AlignVCenter
                                }
                                RComboBox{
                                    id: fileFolderViewCb
                                    width: parent.width*0.5
                                    height: 30
                                    model: ["Default", "ListView", "GridView"]
                                    currentIndex: rFileSystem.GlobalFileFolderView
                                    onCurrentIndexChanged: rFileSystem.GlobalFileFolderView = currentIndex
                                }
                            }
                        }

                        Rectangle{
                            color: rFileSystem.BackgroundColor2
                            opacity: 0.1
                            height: 1
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle{
                            id: cloudAccounts
                            width: parent.width
                            height: 115
                            color: "transparent"

                            Column{
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                spacing: 10

                                Text {
                                    text: qsTr("Manage Cloud Accounts")
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor1
                                    height: 10
                                    verticalAlignment: Text.AlignVCenter
                                }

                                RImageExpandingButton{
                                    id: dropboxInfoBtn
                                    width: parent.width
                                    height: 25
                                    icon.source: "image://xdg/" + rFileSystem.DropboxViewerObj.CloudIcon
                                    fontColor: rFileSystem.IconColor1
                                    text: enabled ? "Linked To " + rFileSystem.DropboxViewerObj.Email : "Not Linked"
                                    enabled: rFileSystem.DropboxViewerObj.IsLinked
                                    onClicked: dropboxViewer.isOpened ? dropboxViewer.close() : dropboxViewer.open()

                                    CloudAccountViewer{
                                        id: dropboxViewer
                                        desiredWidth: settingsPanel.width*0.8
                                        desiredHeight: 240
                                        cloudObject: rFileSystem.DropboxViewerObj
                                    }
                                }

                                RImageExpandingButton{
                                    id: onedriveInfoBtn
                                    width: parent.width
                                    height: 25
                                    icon.source: "image://xdg/" + rFileSystem.OneDriveViewerObj.CloudIcon
                                    fontColor: rFileSystem.IconColor1
                                    text: enabled ? "Linked To " + rFileSystem.OneDriveViewerObj.Email : "Not Linked"
                                    enabled: rFileSystem.OneDriveViewerObj.IsLinked
                                    onClicked: onedriveViewer.isOpened ? onedriveViewer.close() : onedriveViewer.open()

                                    CloudAccountViewer{
                                        id: onedriveViewer
                                        desiredWidth: settingsPanel.width*0.8
                                        desiredHeight: 240
                                        cloudObject: rFileSystem.OneDriveViewerObj
                                    }
                                }

                                RImageExpandingButton{
                                    id: googledriveInfoBtn
                                    width: parent.width
                                    height: 25
                                    icon.source: "image://xdg/" + rFileSystem.GoogleDriveViewerObj.CloudIcon
                                    fontColor: rFileSystem.IconColor1
                                    text: enabled ? "Linked To " + rFileSystem.GoogleDriveViewerObj.Email : "Not Linked"
                                    enabled: rFileSystem.GoogleDriveViewerObj.IsLinked
                                    onClicked: googledriveViewer.isOpened ? googledriveViewer.close() : googledriveViewer.open()

                                    CloudAccountViewer{
                                        id: googledriveViewer
                                        desiredWidth: settingsPanel.width*0.8
                                        desiredHeight: 240
                                        cloudObject: rFileSystem.GoogleDriveViewerObj
                                    }
                                }
                            }
                        }

                        Rectangle{
                            color: rFileSystem.BackgroundColor2
                            opacity: 0.1
                            height: 1
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
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
                                    color: rFileSystem.IconColor1
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                Text {
                                    text: qsTr("Version 1.2")
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor1
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
                                        color: rFileSystem.IconColor1
                                    }
                                }

                                Text {
                                    text: qsTr("Qt Version: 5.12\n Qml Version: 2")
                                    font.pointSize: 10
                                    color: rFileSystem.IconColor1
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
