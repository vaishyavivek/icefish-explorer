import QtQuick 2.7
import QtQuick.Controls 2.2
import "../CustomComponents"

Popup{
    id: indicatorPanel
    padding: 0
    property int widthWhenExpanded
    property bool isOpened: false

    clip: true
    closePolicy: Popup.NoAutoClose

    Rectangle{
        id: bookmarkPanelParentRect
        width: parent.width
        height: parent.height
        border.width: 1
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
                    width: parent.width - closeBBtn.width
                    color: "transparent"
                    Text {
                        width: parent.width
                        height: parent.height
                        text: "PROCESSES"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 12
                        color: rFileSystem.IconColor
                    }
                }
                RImageButton{
                    id: closeBBtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    icon.source: "/local/assets/icons-popup-close.svg"
                    icon.color: rFileSystem.IconColor
                    onClicked: {
                        isOpened = false
                        indicatorPanel.close()
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
                contentHeight: ongoingProcesses.height + waitingProcesses.height

                Rectangle{
                    id: ongoingProcesses
                    property bool isExpanded: false
                    width: parent.width
                    height: isExpanded ? 25 + ongoingProcessesContent.height + noOngoing.height: 25
                    color: "transparent"
                    radius: 5
                    Column{
                        anchors.fill: parent
                        RImageExpandingButton{
                            width: parent.width
                            height: 25
                            text: "Currently Ongoing Processes"
                            icon.source: "/local/assets/icons-" + (ongoingProcesses.sExpanded ? "collapse.svg" : "expand.svg")
                            icon.color: rFileSystem.IconColor
                            onClicked: ongoingProcesses.isExpanded = !ongoingProcesses.isExpanded
                        }
                        ListView{
                            id: ongoingProcessesContent
                            width: parent.width
                            height: count*80
                            visible: ongoingProcesses.isExpanded
                            model: rFileOperator.OngoingProcessList

                            delegate: Rectangle{
                                id: ongoingProcessesContentListDelegate
                                width: parent.width
                                height: 80
                                Column{
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 5

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.25
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.Header
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor
                                        }
                                    }

                                    ProgressBar{
                                        width: parent.width
                                        height: (parent.height - 15)*0.25
                                        from: 0
                                        to: 100
                                        indeterminate: (model.modelData.Progress === -1)
                                        value: model.modelData.Progress
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.25
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.TimeRequired
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor
                                        }
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.25
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.TransferSpeed
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle{
                            id: noOngoing
                            width: parent.width
                            height: visible ? 30 : 0
                            color: "transparent"
                            visible: ongoingProcesses.isExpanded && ongoingProcessesContent.count === 0
                            Text{
                                anchors.fill: parent
                                text: "Nothing to show here"
                                font.family: "Sans Serif"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: rFileSystem.IconColor
                            }
                        }
                    }

                    Behavior on height { PropertyAnimation{ duration: rFileSystem.GlobalAnimationDuration}}
                }

                Rectangle{
                    id: waitingProcesses
                    anchors.top: ongoingProcesses.bottom
                    property bool isExpanded: false
                    width: parent.width
                    height: isExpanded ? 25 + waitingProcessesContent.height + noWaiting.height: 25
                    color: "transparent"
                    radius: 5
                    Column{
                        anchors.fill: parent
                        RImageExpandingButton{
                            width: parent.width
                            height: 25
                            text: "Process waiting in Queue"
                            icon.source: "/local/assets/icons-" + (waitingProcesses.sExpanded ? "collapse.svg" : "expand.svg")
                            icon.color: rFileSystem.IconColor
                            onClicked: waitingProcesses.isExpanded = !waitingProcesses.isExpanded
                        }

                        ListView{
                            id: waitingProcessesContent
                            width: parent.width
                            height: count*80
                            visible: waitingProcesses.isExpanded
                            model: rFileOperator.WaitingProcessList

                            delegate: Rectangle{
                                id: waitingProcessesContentListDelegate
                                width: parent.width
                                height: 80
                                Column{
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 5

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.25
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.Header
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor
                                        }
                                    }

                                    ProgressBar{
                                        width: parent.width
                                        height: (parent.height - 15)*0.25
                                        from: 0
                                        to: 100
                                        indeterminate: (model.modelData.Progress === -1)
                                        value: model.modelData.Progress
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.25
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.TimeRequired
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor
                                        }
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.25
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.TransferSpeed
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle{
                            id: noWaiting
                            width: parent.width
                            height: visible ? 30 : 0
                            color: "transparent"
                            visible: waitingProcesses.isExpanded && waitingProcessesContent.count === 0
                            Text{
                                anchors.fill: parent
                                text: "Nothing to show here"
                                font.family: "Sans Serif"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: rFileSystem.IconColor
                            }
                        }
                    }

                    Behavior on height { PropertyAnimation{ duration: rFileSystem.GlobalAnimationDuration}}
                }
            }
        }
    }


    enter: Transition{
        NumberAnimation{
            property: "width"
            to: indicatorPanel.widthWhenExpanded
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
