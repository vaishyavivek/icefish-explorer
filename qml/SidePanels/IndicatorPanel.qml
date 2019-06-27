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
import "../CustomComponents"

ToolTip{
    id: indicatorPanel
    padding: 0
    property int widthWhenExpanded
    property bool isOpened: false

    clip: true
    closePolicy: Popup.NoAutoClose
    contentWidth: widthWhenExpanded

    background: Rectangle{
        opacity: 0.3
        color: rFileSystem.BackgroundColor1
    }

    Rectangle{
        id: settingsPanelParentRect
        width: parent.width
        height: parent.height
        color: rFileSystem.BackgroundColor1
        border.color: rFileSystem.IconColor1
        border.width: 1
        radius: 5

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
                        color: rFileSystem.IconColor1
                    }
                }
                RImageButton{
                    id: closeBBtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    icon.source: "/local/assets/popup-close.svg"
                    icon.color: rFileSystem.IconColor1
                    onClicked: {
                        isOpened = false
                        indicatorPanel.close()
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
                height: parent.height - headerBar.height - 5
                anchors.horizontalCenter: parent.horizontalCenter
                contentWidth: width
                contentHeight: ongoingProcesses.height + waitingProcesses.height + completedProcesses.height

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
                            icon.source: "/local/assets/" + (ongoingProcesses.isExpanded ? "collapse.svg" : "expand.svg")
                            icon.color: rFileSystem.IconColor1
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
                                            color: rFileSystem.IconColor1
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
                                            color: rFileSystem.IconColor1
                                        }
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.25
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.TransferSpeed
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor1
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
                                color: rFileSystem.IconColor1
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
                            icon.source: "/local/assets/" + (waitingProcesses.isExpanded ? "collapse.svg" : "expand.svg")
                            icon.color: rFileSystem.IconColor1
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
                                            color: rFileSystem.IconColor1
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
                                            color: rFileSystem.IconColor1
                                        }
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.25
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.TransferSpeed
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor1
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
                                color: rFileSystem.IconColor1
                            }
                        }
                    }

                    Behavior on height { PropertyAnimation{ duration: rFileSystem.GlobalAnimationDuration}}
                }

                Rectangle{
                    id: completedProcesses
                    anchors.top: waitingProcesses.bottom
                    property bool isExpanded: false
                    width: parent.width
                    height: isExpanded ? 25 + completedProcessesContent.height + nocompleted.height: 25
                    color: "transparent"
                    radius: 5
                    Column{
                        anchors.fill: parent
                        RImageExpandingButton{
                            width: parent.width
                            height: 25
                            text: "Completed Processes"
                            icon.source: "/local/assets/" + (completedProcesses.sExpanded ? "collapse.svg" : "expand.svg")
                            icon.color: rFileSystem.IconColor1
                            onClicked: completedProcesses.isExpanded = !completedProcesses.isExpanded
                        }

                        ListView{
                            id: completedProcessesContent
                            width: parent.width
                            height: count*60
                            visible: completedProcesses.isExpanded
                            model: rFileOperator.CompletedProcessList

                            delegate: Rectangle{
                                id: completedProcessesContentListDelegate
                                width: parent.width
                                height: 60
                                Column{
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 5

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.33
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.Header
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor1
                                        }
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.33
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.TimeRequired
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor1
                                        }
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: (parent.height - 15)*0.33
                                        color: "transparent"
                                        Text{
                                            text: model.modelData.TransferSpeed
                                            font.family: "Sans Serif"
                                            color: rFileSystem.IconColor1
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle{
                            id: nocompleted
                            width: parent.width
                            height: visible ? 30 : 0
                            color: "transparent"
                            visible: completedProcesses.isExpanded && completedProcessesContent.count === 0
                            Text{
                                anchors.fill: parent
                                text: "Nothing to show here"
                                font.family: "Sans Serif"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: rFileSystem.IconColor1
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
