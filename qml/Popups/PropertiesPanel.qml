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
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import "../CustomComponents"

Popup{
    id: propertiesPanel
    padding: 2
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
    height: 400
    modal: true
    width: 300
    margins: 0

    Rectangle{
        id: propertiesPanelParentRect
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: rFileSystem.BackgroundColor
        border.width: 0

        TabView{
            id: propertiesTabBar
            width: parent.width
            height: parent.height
            clip: true

            style: TabViewStyle {
                frameOverlap: 1
                tab: Rectangle {
                    color: styleData.selected ? rFileSystem.HighlightColor : "#b4ccd3"
                    implicitWidth: propertiesTabBar.width*0.3
                    implicitHeight: implicitWidth*0.3
                    Text {
                        anchors.centerIn: parent
                        text: styleData.title
                        font.bold: styleData.selected
                        font.pointSize: 10
                        color: styleData.selected ? rFileSystem.IconColor : "black"
                    }
                }
            }

            Tab{
                title: "General"
                Rectangle{
                    border.width: 1
                    color: "transparent"
                    Column{
                        anchors.fill: parent
                        spacing: 10
                        Rectangle{
                            id: imageRect
                            width: parent.width
                            height: 80
                            color: "transparent"
                            Image {
                                id: image
                                source: "file://" + qtModel.Properties.IconPath
                                sourceSize.width: parent.height
                                sourceSize.height: parent.height
                                anchors.centerIn: parent
                            }
                        }

                        Rectangle{
                            id: name
                            width: parent.width*0.75
                            height: 30
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "transparent"
                            Row{
                                anchors.fill: parent
                                spacing: 2
                                TextField{
                                    id: nameField
                                    width: parent.width - parent.height
                                    height: parent.height
                                    text: qtModel.Properties.Name
                                }
                                RImageButton{
                                    anchors.verticalCenter: parent.verticalCenter
                                    height: parent.height*0.75
                                    width: height
                                    icon.source: "/local/assets/check.svg"
                                    onClicked: qtModel.Properties.Name = nameField.text
                                }
                            }
                        }
                        Rectangle{
                            width: parent.width
                            height: 10
                            color: "transparent"
                        }

                        Row{
                            width: parent.width
                            height: 15
                            spacing: 10
                            Text {
                                width: parent.width*0.25
                                height: 15
                                text: "Path:"
                                font.bold: true
                                clip: true
                                horizontalAlignment: Text.AlignRight
                            }
                            Text {
                                width: parent.width*0.75 - 10
                                height: 15
                                text: qtModel.Properties.Path
                            }
                        }

                        Row{
                            width: parent.width
                            height: 15
                            spacing: 10
                            Text {
                                width: parent.width*0.25
                                height: 15
                                text: "Type:"
                                font.bold: true
                                horizontalAlignment: Text.AlignRight
                            }

                            Text {
                                width: parent.width*0.75 - 10
                                height: 15
                                text: qtModel.Properties.Type
                            }
                        }

                        Row{
                            width: parent.width
                            height: 30
                            spacing: 10
                            Text {
                                width: parent.width*0.25
                                height: 30
                                text: "Size:"
                                font.bold: true
                                horizontalAlignment: Text.AlignRight
                            }
                            Text {
                                width: parent.width*0.75 - 10
                                height: 30
                                text: qtModel.Properties.Size
                            }
                        }

                        Row{
                            width: parent.width
                            height: 15
                            spacing: 10
                            Text {
                                width: parent.width*0.25
                                height: 15
                                text: "Created:"
                                font.bold: true
                                horizontalAlignment: Text.AlignRight
                            }
                            Text {
                                width: parent.width*0.75 - 10
                                height: 15
                                text: qtModel.Properties.Created
                            }
                        }

                        Row{
                            width: parent.width
                            height: 15
                            spacing: 10
                            Text {
                                width: parent.width*0.25
                                height: 15
                                text: "Modified:"
                                font.bold: true
                                horizontalAlignment: Text.AlignRight
                            }
                            Text {
                                width: parent.width*0.75 - 10
                                height: 15
                                text: qtModel.Properties.Modified
                            }
                        }

                        Row{
                            width: parent.width
                            height: 15
                            spacing: 10
                            Text {
                                width: parent.width*0.25
                                height: 15
                                text: "Hidden:"
                                font.bold: true
                                horizontalAlignment: Text.AlignRight
                            }
                            RCheckBox {
                                width: height
                                height: 15
                                checked: qtModel.Properties.IsHidden
                            }
                        }
                    }
                }
            }

            Tab{
                title: "Permissions"
                Rectangle{
                    border.width: 1
                    color: "transparent"

                    Column{
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 20

                        GroupBox{
                            id: permissionGroup
                            title: "Permissions"
                            width: parent.width
                            height: 170
                            anchors.horizontalCenter: parent.horizontalCenter

                            label: Label {
                                x: permissionGroup.leftPadding
                                width: permissionGroup.availableWidth
                                text: permissionGroup.title
                                font.bold: true
                                font.pointSize: 10
                                color: "skyblue"
                                elide: Text.ElideRight
                            }


                            Column{
                                width: parent.width*0.9
                                height: parent.height*0.9
                                anchors.centerIn: parent
                                spacing: 10

                                Row{
                                    width: parent.width
                                    height: 15
                                    spacing: 15

                                    Text {
                                        width: parent.width*0.48
                                        height: parent.height
                                        text: ""
                                    }

                                    Text{
                                        width: parent.width*0.1
                                        height: parent.height
                                        text: "Read"
                                    }
                                    Text{
                                        width: parent.width*0.1
                                        height: parent.height
                                        text: "Write"
                                    }
                                    Text{
                                        width: parent.width*0.1
                                        height: parent.height
                                        text: "Exec"
                                    }
                                }

                                Row{
                                    width: parent.width
                                    height: 15
                                    spacing: 20

                                    Text {
                                        width: parent.width*0.5
                                        height: parent.height
                                        text: "Owner"
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.ReadOwner
                                        onCheckedChanged: qtModel.Properties.ReadOwner = checked
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.WriteOwner
                                        onCheckedChanged: qtModel.Properties.WriteOwner = checked
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.ExecOwner
                                        onCheckedChanged: qtModel.Properties.ExecOwner = checked
                                    }
                                }

                                Row{
                                    width: parent.width
                                    height: 15
                                    spacing: 20

                                    Text {
                                        width: parent.width*0.5
                                        text: "User"
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.ReadUser
                                        onCheckedChanged: qtModel.Properties.ReadUser = checked
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.WriteUser
                                        onCheckedChanged: qtModel.Properties.WriteUser = checked
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.ExecUser
                                        onCheckedChanged: qtModel.Properties.ExecUser = checked
                                    }
                                }

                                Row{
                                    width: parent.width
                                    height: 15
                                    spacing: 20

                                    Text {
                                        width: parent.width*0.5
                                        text: "Group"
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.ReadGroup
                                        onCheckedChanged: qtModel.Properties.ReadGroup = checked
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.WriteGroup
                                        onCheckedChanged: qtModel.Properties.WriteGroup = checked
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.ExecGroup
                                        onCheckedChanged: qtModel.Properties.ExecGroup = checked
                                    }
                                }

                                Row{
                                    width: parent.width
                                    height: 15
                                    spacing: 20

                                    Text {
                                        width: parent.width*0.5
                                        text: "Other"
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.ReadOther
                                        onCheckedChanged: qtModel.Properties.ReadOther = checked
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.WriteOther
                                        onCheckedChanged: qtModel.Properties.WriteOther = checked
                                    }
                                    RCheckBox{
                                        height: parent.height
                                        width: height
                                        checked: qtModel.Properties.ExecOther
                                        onCheckedChanged: qtModel.Properties.ExecOther = checked
                                    }
                                }
                            }
                        }

                        GroupBox{
                            id: ownershipGroup
                            title: "Ownership"
                            width: parent.width
                            height: 100
                            anchors.horizontalCenter: parent.horizontalCenter

                            label: Label {
                                x: ownershipGroup.leftPadding
                                width: ownershipGroup.availableWidth
                                text: ownershipGroup.title
                                font.bold: true
                                font.pointSize: 10
                                color: "skyblue"
                                elide: Text.ElideRight
                            }

                            Column{
                                width: parent.width*0.9
                                height: parent.height*0.9
                                anchors.centerIn: parent
                                spacing: 10

                                Row{
                                    width: parent.width
                                    height: 15
                                    spacing: 10
                                    Text {
                                        width: parent.width*0.25
                                        height: 15
                                        text: "Owner:"
                                        font.bold: true
                                        horizontalAlignment: Text.AlignRight
                                    }
                                    Text {
                                        width: parent.width*0.75 - 10
                                        height: 15
                                        text: qtModel.Properties.Owner
                                    }
                                }

                                Row{
                                    width: parent.width
                                    height: 15
                                    spacing: 10
                                    Text {
                                        width: parent.width*0.25
                                        height: 15
                                        text: "Group:"
                                        font.bold: true
                                        horizontalAlignment: Text.AlignRight
                                    }
                                    Text {
                                        width: parent.width*0.75 - 10
                                        height: 15
                                        text: qtModel.Properties.Group
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        RImageButton{
            id: closebtn
            height: propertiesTabBar.width*0.09
            width: height
            anchors.right: parent.right
            anchors.top: parent.top
            icon.source: "/local/assets/close.svg"
            icon.color: rFileSystem.IconColor
            onClicked: propertiesPanel.close()
        }
    }

    enter: Transition{
        NumberAnimation{
            property: "width"
            from: 0
            to: 300
            duration: rFileSystem.GlobalAnimationDuration
        }
        NumberAnimation{
            property: "height"
            from: 0
            to: 400
            duration: rFileSystem.GlobalAnimationDuration
        }
    }

    exit: Transition{
        NumberAnimation{
            property: "width"
            to: 0
            duration: rFileSystem.GlobalAnimationDuration
        }
        NumberAnimation{
            property: "height"
            to: 0
            duration: rFileSystem.GlobalAnimationDuration
        }
    }

    onOpened: {
        propertiesTabBar.currentIndex = 0
    }
}
