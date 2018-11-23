import QtQuick 2.7
import QtQuick.Controls 2.2

Popup{
    id: itemSortingRolesPanel
    property bool isOpened: false
    property int oldY
    property int newY

    property string sortingRole
    property string sortingOrder
    property string sortingPreference
    property string text: sortingRole + ' ' + sortingOrder

    padding: 2
    modal: false
    height: 275

    Rectangle{
        id: notificationPanelParentRect
        width: parent.width
        height: parent.height
        color: mainWindow.color

        Column{
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            anchors.fill: parent
            spacing: 5
            Rectangle{
                width: parent.width
                height: 135
                ButtonGroup{
                    id: roleTypeButtonGroup
                    onClicked: {
                        sortingRole = button.text
                        qtModel.SortingRole = button.text.replace(' ', '')
                    }
                }
                Column{
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    anchors.fill: parent
                    spacing: 1
                    Text {
                        width: parent.width
                        height: 15
                        text: qsTr("Sorting Roles")
                    }

                    RTextButton{
                        width: parent.width
                        height: 30
                        text: "Name"
                        checkable: true
                        checked: (sortingRole === "Name")
                        ButtonGroup.group: roleTypeButtonGroup
                    }
                    RTextButton{
                        width: parent.width
                        height: 30
                        text: "Type"
                        checkable: true
                        checked: (sortingRole === "Type")
                        ButtonGroup.group: roleTypeButtonGroup
                    }
                    RTextButton{
                        width: parent.width
                        height: 30
                        text: "Size"
                        checkable: true
                        checked: (sortingRole === "Size")
                        ButtonGroup.group: roleTypeButtonGroup
                    }
                    RTextButton{
                        width: parent.width
                        height: 30
                        text: "Time"
                        checkable: true
                        checked: (sortingRole === "Time")
                        ButtonGroup.group: roleTypeButtonGroup
                    }
                }
            }

            Rectangle{
                width: parent.width
                height: 45
                ButtonGroup{
                    id: sortingOrderButtonGroup
                    onClicked: {
                        sortingOrder = button.text
                        qtModel.SortingOrder = button.text
                    }
                }
                Column{
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    anchors.fill: parent
                    Text{
                        width: parent.width
                        height: 15
                        text: qsTr("Sorting Order")
                    }

                    Row{
                        width: 60
                        height: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        RImageButton{
                            height: parent.height
                            width: height
                            checkable: true
                            checked: (sortingOrder === "Ascending")
                            text: "Ascending"
                            iconPath: "/local/Resources/icons-sort-up.svg"
                            ButtonGroup.group: sortingOrderButtonGroup
                        }
                        RImageButton{
                            height: parent.height
                            width: height
                            checkable: true
                            checked: (sortingOrder !== "Ascending")
                            text: "Descending"
                            iconPath: "/local/Resources/icons-sort-down.svg"
                            ButtonGroup.group: sortingOrderButtonGroup
                        }
                    }
                }
            }

            Rectangle{
                width: parent.width
                height: 45
                ButtonGroup{
                    id: sortingPreferenceButtonGroup
                    onClicked: {
                        sortingPreference = button.text
                        qtModel.SortingPreference = button.text.replace(' ', '')
                    }
                }
                Column{
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    anchors.fill: parent
                    Text{
                        width: parent.width
                        height: 15
                        text: qsTr("Sorting Preference")
                    }

                    Row{
                        width: 60
                        height: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        RImageButton{
                            height: parent.height
                            width: height
                            checkable: true
                            checked: (sortingPreference === "DirectoryFirst")
                            text: "Directory First"
                            iconPath: "/local/Resources/icons-sort-dir.svg"
                            ButtonGroup.group: sortingPreferenceButtonGroup
                        }
                        RImageButton{
                            height: parent.height
                            width: height
                            checkable: true
                            checked: (sortingPreference !== "DirectoryFirst")
                            text: "File First"
                            iconPath: "/local/Resources/icons-sort-file.svg"
                            ButtonGroup.group: sortingPreferenceButtonGroup
                        }
                    }
                }
            }

            RTextButton{
                width: parent.width
                height: 30
                text: "Apply"
                onClicked: {
                    qtModel.reloadCurrentDirectory()
                    isOpened = false
                    itemSortingRolesPanel.close()
                }
            }
        }
    }

    enter: Transition{
        NumberAnimation{
            property: "y"
            from: oldY
            to: newY
            duration: 250
            easing.type: Easing.InOutQuad
        }
    }

    exit: Transition{
        NumberAnimation{
            property: "y"
            from: newY
            to: oldY
            duration: 250
            easing.type: Easing.OutInQuad
        }
    }
}
