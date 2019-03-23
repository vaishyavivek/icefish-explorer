import QtQuick 2.7
import QtQuick.Controls 2.12
import "../CustomComponents"

Popup{
    id: sortingPanel
    property bool isOpened: false
    property int oldY
    property int newY
    property string currentSelection: sortingRole.currentItem.role + " " + sortingOrder.currentItem.order

    padding: 0
    margins: 0
    modal: true
    height: 278

    Rectangle{
        width: parent.width
        height: parent.height
        color: rFileSystem.BackgroundColor
        Column{
            anchors.margins: 5
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
                    color: "transparent"
                    Text {
                        width: parent.width
                        height: parent.height
                        anchors.leftMargin: 5
                        text: qsTr("Sorting Roles")
                        color: rFileSystem.IconColor
                        font.pointSize: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                delegate: Rectangle{
                    property string role: model.role
                    width: parent.width
                    height: 28
                    color: (sortingRole.currentIndex == index) ? rFileSystem.SelectedColor : "transparent"

                    Rectangle{
                        id: animatingRect
                        anchors.fill: parent
                        radius: 5
                        opacity: 0.3
                        color: "transparent"
                    }


                    PropertyAnimation{
                        id: mouseEnteredAnimation
                        target: animatingRect
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: rFileSystem.HighlightColor
                        duration: rFileSystem.GlobalAnimationDuration
                    }
                    PropertyAnimation{
                        id: mouseExitedAnimation
                        target: animatingRect
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: "transparent"
                        duration: rFileSystem.GlobalAnimationDuration
                    }

                    Text {
                        width: parent.width
                        height: parent.height
                        text: role
                        color: rFileSystem.IconColor
                        font.family: "Sans Serif"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: sortingRole.currentIndex = index
                        onEntered: mouseEnteredAnimation.start()
                        onExited: mouseExitedAnimation.start()
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
                color: "transparent"
                Text {
                    width: parent.width
                    height: parent.height
                    anchors.leftMargin: 5
                    text: qsTr("Sorting Order")
                    color: rFileSystem.IconColor
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
                    color: (sortingOrder.currentIndex == index) ? rFileSystem.SelectedColor : "transparent"

                    Rectangle{
                        id: animatingRectS
                        anchors.fill: parent
                        radius: 5
                        opacity: 0.3
                        color: "transparent"
                    }


                    PropertyAnimation{
                        id: mouseEnteredAnimationS
                        target: animatingRectS
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: rFileSystem.HighlightColor
                        duration: rFileSystem.GlobalAnimationDuration
                    }
                    PropertyAnimation{
                        id: mouseExitedAnimationS
                        target: animatingRectS
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: "transparent"
                        duration: rFileSystem.GlobalAnimationDuration
                    }

                    Image {
                        source: image
                        sourceSize.height: parent.height*0.9
                        sourceSize.width: parent.height*0.9
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: sortingOrder.currentIndex = index
                        onEntered: mouseEnteredAnimationS.start()
                        onExited: mouseExitedAnimationS.start()
                    }
                }

                model: ListModel{
                    ListElement{
                        image: "/local/assets/sort-up.svg"
                        order: "Ascending"
                    }
                    ListElement{
                        image: "/local/assets/sort-down.svg"
                        order: "Descending"
                    }
                }
            }

            Rectangle{
                id: sortingPreferenceHeader
                width: parent.width
                height: 11
                color: "transparent"
                Text {
                    width: parent.width
                    height: parent.height
                    anchors.leftMargin: 5
                    text: qsTr("Sorting Preference")
                    color: rFileSystem.IconColor
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
                    color: (sortingPreference.currentIndex == index) ? rFileSystem.SelectedColor : "transparent"

                    Rectangle{
                        id: animatingRectP
                        anchors.fill: parent
                        radius: 5
                        opacity: 0.3
                        color: "transparent"
                    }


                    PropertyAnimation{
                        id: mouseEnteredAnimationP
                        target: animatingRectP
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: rFileSystem.HighlightColor
                        duration: rFileSystem.GlobalAnimationDuration
                    }
                    PropertyAnimation{
                        id: mouseExitedAnimationP
                        target: animatingRectP
                        property: "color"
                        easing.type: Easing.OutInQuad
                        to: "transparent"
                        duration: rFileSystem.GlobalAnimationDuration
                    }

                    Image {
                        source: preference
                        sourceSize.height: parent.height*0.9
                        sourceSize.width: parent.height*0.9
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: sortingPreference.currentIndex = index
                        onEntered: mouseEnteredAnimationP.start()
                        onExited: mouseExitedAnimationP.start()
                    }
                }

                model: ListModel{
                    ListElement{ preference: "/local/assets/folder.svg"}
                    ListElement{ preference: "/local/assets/file.svg"}
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
