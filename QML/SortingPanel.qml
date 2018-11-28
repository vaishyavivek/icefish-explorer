import QtQuick 2.7
import QtQuick.Controls 2.2

Popup{
    id: sortingPanel
    property bool isOpened: false
    property int oldY
    property int newY
    property string currentSelection: sortingRole.currentItem.role + " " + sortingOrder.currentItem.order

    padding: 2
    modal: false
    height: 278

    Rectangle{
        width: parent.width
        height: parent.height
        color: mainWindow.color
        Column{
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            anchors.fill: parent
            spacing: 5

            ListView{
                id: sortingRole
                width: parent.width
                height: 135
                currentIndex: qtModel.SortingRole

                header: Rectangle{
                    width: parent.width
                    height: 21
                    Text {
                        width: parent.width
                        height: parent.height
                        anchors.leftMargin: 5
                        text: qsTr("Sorting Roles")
                        font.pointSize: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                delegate: Rectangle{
                    property string role: model.role
                    width: parent.width
                    height: 28
                    color: (sortingRole.currentIndex == index) ? "lightblue" : "transparent"

                    Rectangle{
                        anchors.fill: parent
                        opacity: 0.2
                        color: "#c4d7dd"
                    }

                    Text {
                        width: parent.width
                        height: parent.height
                        text: role
                        font.family: "Sans Serif"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: sortingRole.currentIndex = index
                    }
                }

                model: ListModel{
                    ListElement{ role: "Name"}
                    ListElement{ role: "Type"}
                    ListElement{ role: "Size"}
                    ListElement{ role: "Time"}
                }
            }

            Rectangle{
                id: sortingOrderHeader
                width: parent.width
                height: 11
                Text {
                    width: parent.width
                    height: parent.height
                    anchors.leftMargin: 5
                    text: qsTr("Sorting Order")
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ListView{
                id: sortingOrder
                width: parent.width
                height: 28
                orientation: Qt.Horizontal
                currentIndex: qtModel.SortingOrder

                delegate: Rectangle{
                    property string order: model.order
                    width: sortingOrder.width/2
                    height: 28
                    color: (sortingOrder.currentIndex == index) ? "lightblue" : "transparent"

                    Rectangle{
                        anchors.fill: parent
                        opacity: 0.2
                        color: "#c4d7dd"
                    }

                    Image {
                        source: image
                        sourceSize.height: parent.height*0.9
                        sourceSize.width: parent.height*0.9
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: sortingOrder.currentIndex = index
                    }
                }

                model: ListModel{
                    ListElement{
                        image: "/local/Resources/icons-sort-up.svg"
                        order: "Ascending"
                    }
                    ListElement{
                        image: "/local/Resources/icons-sort-down.svg"
                        order: "Descending"
                    }
                }
            }

            Rectangle{
                id: sortingPreferenceHeader
                width: parent.width
                height: 11
                Text {
                    width: parent.width
                    height: parent.height
                    anchors.leftMargin: 5
                    text: qsTr("Sorting Preference")
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ListView{
                id: sortingPreference
                width: parent.width
                height: 28
                orientation: Qt.Horizontal
                currentIndex: qtModel.SortingPreference

                delegate: Rectangle{
                    width: sortingPreference.width/2
                    height: 28
                    color: (sortingPreference.currentIndex == index) ? "lightblue" : "transparent"

                    Rectangle{
                        anchors.fill: parent
                        opacity: 0.2
                        color: "#c4d7dd"
                    }

                    Image {
                        source: preference
                        sourceSize.height: parent.height*0.9
                        sourceSize.width: parent.height*0.9
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: sortingPreference.currentIndex = index
                    }
                }

                model: ListModel{
                    ListElement{ preference: "/local/Resources/icons-folder.svg"}
                    ListElement{ preference: "/local/Resources/icons-file.svg"}
                }
            }

            RTextButton{
                width: parent.width
                height: 30
                text: "Apply"
                onClicked: {
                    qtModel.SortingRole = sortingRole.currentIndex
                    qtModel.SortingOrder = sortingOrder.currentIndex
                    qtModel.SortingPreference = sortingPreference.currentIndex
                    qtModel.reloadCurrentDirectory()
                    isOpened = false
                    sortingPanel.close()
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
