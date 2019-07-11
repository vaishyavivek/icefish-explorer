/* $Id: StartPage.qml
 * IceFish Explorer is a free File Manager for Linux Desktops for managing
 * local files as well as files on cloud, Dropbox, Onedrive, Googledrive.
 * Additionally, it also serves as a multimedia explorer for your photos,
 * music, videos, documents and other files by providing built-in plugins
 * to open them.
 * © IceFish Community, 2019
 *
 * This file is part of IceFish Explorer.
 *
 * IceFish Explorer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * IceFish Explorer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with IceFish Explorer.
 * If not, see <http://www.gnu.org/licenses/>.
 *
 * The project is hosted here,
 * http://www.icefish.tech/index/explorer/0-5
*/

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import "CustomComponents"

Rectangle {
    id: startPage
    anchors.fill: parent
    color: rFileSystem.BackgroundColor1

    ScrollView{
        width: parent.width - 20
        height: parent.height - 20
        anchors.centerIn: parent
        clip: true

        Column{
            width: parent.width
            height: 602
            spacing: 10

            TextField{
                id: textField
                width: parent.width - 10
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: "Enter your desired directory path or search query"
                onAccepted: rFileSystem.createNewTab(text)

                background: Rectangle{
                    implicitHeight: parent.height - 5
                    border.width: 1
                    border.color: textField.focus ? rFileSystem.HighlightColor : "grey"
                    radius: 5

                    RectangularGlow{
                        anchors.fill: parent
                        glowRadius: 5
                        spread: 0.2
                        color: rFileSystem.BackgroundColor2
                        cornerRadius: parent.radius
                        z: -1
                    }
                }
            }

            Rectangle{
                color: rFileSystem.BackgroundColor2
                opacity: 0.1
                height: 2
                width: parent.width
            }

            Row{
                width: parent.width
                height: 280
                spacing: 20

                Rectangle{
                    id: fileManagerParentRect
                    width: parent.width*0.5 - 10
                    height: 270
                    color: "transparent"

                    Rectangle{
                        id: fileManager
                        width: parent.width - 10
                        height: 260
                        anchors.centerIn: parent
                        border.width: 2
                        border.color: "#2196F3"
                        radius: 5
                        color: rFileSystem.BackgroundColor1

                        Column{
                            width: parent.width
                            height: parent.height - 20
                            anchors.margins: 10
                            //spacing: 10

                            Text {
                                width: parent.width
                                height: 40//parent.height
                                text: qsTr("     File Manager")
                                font.bold: true
                                font.pointSize: 14
                                verticalAlignment: Text.AlignVCenter
                                color: Qt.darker("grey")
                            }

                            Rectangle{
                                width: parent.width - 30
                                height: 2
                                color: "#2196F3"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Rectangle{
                                width: parent.width
                                height: 10
                                color: "transparent"
                            }

                            Row{
                                width: parent.width - 20
                                height: parent.height - 40
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 20

                                Canvas{
                                    id: canvas
                                    property var picturesCount: rFileSystem.PhotoViewProvider.PhotoCount
                                    property var videoCount: rFileSystem.VideoViewProvider.VideoCount

                                    property var stoppersModelValues: [200, picturesCount, 240, videoCount, 453, 1000]

                                    property var totalMediaCount: stoppersModelValues.reduce((a, b) => a + b, 0)

                                    property var stoppersModelPercent: stoppersModelValues.map(item => item/totalMediaCount)

                                    property var stoppersModelName: ["Documents", "Pictures", "Music", "Videos", "Archives", "Others"]
                                    property var stoppersModelColors: ["#F57F17", "#01579B", "#D81B60", "#7B1FA2", "tomato", "#FFA000"]
                                    property var execCommands: ["docs", "pictures", "music", "video", "archives", "other"]
                                    property var stoppersModelFunctions: ["Have a Look", "Browse in Gallery", "Open Music Player", "Open Media Manager", "List Archives", "See All"]
                                    property real center: width*0.5
                                    height: width
                                    width: parent.width*0.5 - 20
                                    antialiasing: true
                                    anchors.verticalCenter: parent.verticalCenter

                                    onPaint: {
                                        var ctx = getContext("2d");
                                        ctx.lineWidth = 10;
                                        ctx.lineCap = "round"
                                        ctx.lineJoin = "round"

                                        var i;
                                        var lastValue = 0;
                                        for(i = 0; i < 6; i++){
                                            ctx.beginPath();
                                            ctx.moveTo(center, center);
                                            ctx.strokeStyle = stoppersModelColors[i];
                                            ctx.fillStyle = Qt.lighter(stoppersModelColors[i]);

                                            var value = stoppersModelValues[i]/totalMediaCount + lastValue;
                                            ctx.arc(center, center, center - 5, lastValue*2*Math.PI, value*2*Math.PI);
                                            lastValue = value;
                                            stoppersModelPercent[i] = value;

                                            ctx.stroke();
                                            ctx.fill();
                                            ctx.closePath();
                                        }

                                        ctx.beginPath();
                                        ctx.moveTo(center, center);
                                        ctx.strokeStyle = "white"
                                        ctx.fillStyle = Qt.lighter("white")
                                        ctx.arc(center, center, 10, 0, 2*Math.PI);
                                        ctx.stroke();
                                        ctx.fill();
                                        ctx.closePath();
                                    }

                                    RectangularGlow{
                                        anchors.fill: canvas
                                        glowRadius: 25
                                        spread: 0.2
                                        color: rFileSystem.BackgroundColor2
                                        cornerRadius: canvas.width/2
                                        z: -1
                                    }
                                }


                                ListView{
                                    id: dataFilledStatusListView
                                    width: parent.width - canvas.width
                                    height: 180
                                    anchors.verticalCenter: parent.verticalCenter
                                    model: canvas.stoppersModelPercent
                                    spacing: 5
                                    delegate: Rectangle{
                                        width: parent.width
                                        height: 25
                                        color: "transparent"

                                        Row{
                                            anchors.fill: parent
                                            spacing: 10

                                            Rectangle{
                                                id: colorRect
                                                height: parent.height
                                                width: height*2
                                                color: canvas.stoppersModelColors[index]
                                                radius: 5
                                                Text{
                                                    width: parent.width
                                                    height: parent.height
                                                    text: modelData.toFixed(2)*100 + "%"
                                                    verticalAlignment: Text.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    color: rFileSystem.IconColor2
                                                }
                                            }

                                            Rectangle{
                                                id: nameRect
                                                height: parent.height
                                                width: parent.width - 115
                                                color: "transparent"
                                                Text{
                                                    id: name
                                                    width: parent.width
                                                    height: parent.height
                                                    text: canvas.stoppersModelName[index] + " (" + canvas.stoppersModelValues[index] + ")"
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: Qt.darker("grey")
                                                }
                                            }
                                        }

                                        MouseArea{
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onEntered: name.font.underline = true
                                            onExited: {
                                                name.font.underline = false
                                                name.color = Qt.darker("grey")
                                            }
                                            onClicked: {
                                                name.color = Qt.darker(rFileSystem.HighlightColor)
                                                rFileSystem.createNewTab(canvas.execCommands[index])
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        /*Canvas{
                            property real center: width/2
                            width: parent.width
                            height: parent.height

                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.fillStyle = "#FFF";
                                ctx.globalAlpha = 0.1;
                                ctx.beginPath();
                                ctx.arc(center, center, center + 20, 0, Math.PI * 2);
                                ctx.fill();
                            }
                        }*/
                    }


                    RectangularGlow{
                        anchors.fill: fileManager
                        glowRadius: 5
                        spread: 0.2
                        color: rFileSystem.BackgroundColor2
                        cornerRadius: fileManager.radius
                        z: -1
                    }
                }




                Rectangle{
                    id: systemCleanerParentRect
                    width: parent.width*0.5 - 10
                    height: 270
                    color: "transparent"

                    Rectangle{
                        id: systemCleaner
                        width: parent.width - 10
                        height: 260
                        anchors.centerIn: parent
                        border.width: 2
                        border.color: "#26A69A"
                        radius: 5
                        color: rFileSystem.BackgroundColor1

                        Column{
                            width: parent.width
                            height: parent.height - 20
                            anchors.margins: 10
                            //spacing: 10

                            Text {
                                width: parent.width
                                height: 40//parent.height
                                text: qsTr("     System Cleaner")
                                font.bold: true
                                font.pointSize: 14
                                verticalAlignment: Text.AlignVCenter
                                color: Qt.darker("grey")
                            }

                            Rectangle{
                                width: parent.width - 30
                                height: 2
                                color: "#26A69A"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Rectangle{
                                width: parent.width
                                height: 10
                                color: "transparent"
                            }

                            Row{
                                width: parent.width - 20
                                height: parent.height - 40
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 40

                                Canvas{
                                    id: diskCleanerCanvas
                                    property real usedSpace: 0
                                    property real totalSpace: 1
                                    property real usedPercent: usedSpace/totalSpace
                                    property real center: height/2

                                    width: parent.width*0.5
                                    height: width

                                    onPaint: {
                                        var ctx = getContext("2d");
                                        ctx.lineWidth = 15;
                                        ctx.lineCap = "round"
                                        ctx.lineJoin = "round"

                                        var startAngle = 2*Math.PI/3;
                                        var angle = 2*Math.PI*usedPercent*0.833

                                        ctx.strokeStyle = "#90A4AE";
                                        ctx.beginPath();
                                        ctx.arc(center, center, center - 10, startAngle + angle, Math.PI/3);
                                        ctx.stroke();
                                        ctx.closePath();

                                        ctx.strokeStyle = "#1565C0";
                                        ctx.beginPath();
                                        ctx.arc(center, center, center - 10, startAngle, startAngle + angle);
                                        ctx.stroke();
                                        ctx.closePath();

                                        ctx.globalAlpha = 0.1;
                                        ctx.lineWidth = 5
                                        ctx.strokeStyle = "#FFF";
                                        ctx.beginPath();
                                        ctx.arc(center, center, center - 10, startAngle, Math.PI/3);
                                        ctx.stroke();
                                        ctx.closePath();
                                    }

                                    Image {
                                        source: "/local/assets/hard-disk.png"
                                        sourceSize.width: parent.width*0.3
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.bottom: parent.bottom
                                    }

                                    Text {
                                        text: qsTr(parent.usedPercent.toFixed(1)*100 + "%")
                                        anchors.centerIn: parent
                                        color: Qt.darker("grey")
                                        font.pointSize: 16
                                    }

                                    Text {
                                        id: usedText
                                        text: qsTr((parent.usedSpace/1024).toFixed(2) + " GB used of")
                                        anchors.top: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: Qt.darker("grey")
                                    }

                                    Text {
                                        id: totalText
                                        text: qsTr((parent.totalSpace/1024).toFixed(2) + " GB")
                                        anchors.top: usedText.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: Qt.darker("grey")
                                    }
                                }

                                Column{
                                    width: parent.width - diskCleanerCanvas.width - 50
                                    height: parent.height

                                    Canvas{
                                        id: ramCleanerCanvas
                                        property real usedSpace: 0
                                        property real totalSpace: 1
                                        property real usedPercent: usedSpace/totalSpace
                                        property real center: height/2

                                        width: parent.width
                                        height: width - 10

                                        onPaint: {
                                            var ctx = getContext("2d");
                                            ctx.lineWidth = 15;
                                            ctx.lineCap = "round"
                                            ctx.lineJoin = "round"

                                            var startAngle = 2*Math.PI/3;
                                            var angle = 2*Math.PI*usedPercent*0.833

                                            ctx.strokeStyle = "#90A4AE";
                                            ctx.beginPath();
                                            ctx.arc(center, center, center - 10, startAngle + angle, Math.PI/3);
                                            ctx.stroke();
                                            ctx.closePath();

                                            ctx.strokeStyle = "#1565C0";
                                            ctx.beginPath();
                                            ctx.arc(center, center, center - 10, startAngle, startAngle + angle);
                                            ctx.stroke();
                                            ctx.closePath();

                                            ctx.globalAlpha = 0.1;
                                            ctx.lineWidth = 5
                                            ctx.strokeStyle = "#FFF";
                                            ctx.beginPath();
                                            ctx.arc(center, center, center - 10, startAngle, Math.PI/3);
                                            ctx.stroke();
                                            ctx.closePath();
                                        }

                                        Image {
                                            source: "/local/assets/ram.png"
                                            sourceSize.width: parent.width*0.3
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.bottom: parent.bottom
                                        }

                                        Text {
                                            text: qsTr(parent.usedPercent.toFixed(1)*100 + "%")
                                            anchors.centerIn: parent
                                            color: Qt.darker("grey")
                                            font.pointSize: 16
                                        }

                                        Text {
                                            id: usedTextR
                                            text: qsTr((parent.usedSpace/1024).toFixed(2) + " GB used of")
                                            anchors.top: parent.bottom
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: Qt.darker("grey")
                                        }

                                        Text {
                                            id: totalTextR
                                            text: qsTr((parent.totalSpace/1024).toFixed(2) + " GB")
                                            anchors.top: usedTextR.bottom
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: Qt.darker("grey")
                                        }
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: 40
                                        color: "transparent"
                                    }

                                    RTextButton{
                                        width: parent.width
                                        height: 30
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Scan Now"
                                        font.bold: true
                                        font.pointSize: 14
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: 5
                                        color: "transparent"
                                    }

                                    Text {
                                        width: parent.width
                                        height: 15
                                        text: qsTr("Last Scanned on \nDD:MM:YY")
                                        font.pointSize: 8
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        color: Qt.darker("lightgrey")
                                    }
                                }
                            }
                        }
                    }

                    RectangularGlow{
                        anchors.fill: systemCleaner
                        glowRadius: 5
                        spread: 0.2
                        color: rFileSystem.BackgroundColor2
                        cornerRadius: systemCleaner.radius
                        z: -1
                    }
                }


            }

            Rectangle{
                id: diskGridViewParentEffectRect
                width: parent.width
                height: 200*Math.ceil(rFileSystem.DiskDataList.length/3) + 70
                color: "transparent"

                Rectangle{
                    id: diskGridViewParentRect
                    width: parent.width - 10
                    height: parent.height - 10//200*Math.ceil(rFileSystem.DiskDataList.length/3) + 60
                    anchors.centerIn: parent
                    color: rFileSystem.BackgroundColor1
                    border.width: 2
                    border.color: "#FBC02D"
                    radius: 5

                    Column{
                        width: parent.width
                        height: parent.height - 20
                        anchors.margins: 10
                        //spacing: 10

                        Text {
                            width: parent.width
                            height: 40//parent.height
                            text: qsTr("     Disk Manager")
                            font.bold: true
                            font.pointSize: 14
                            verticalAlignment: Text.AlignVCenter
                            color: Qt.darker("grey")
                        }

                        Rectangle{
                            width: parent.width - 30
                            height: 2
                            color: "#FBC02D"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle{
                            width: parent.width
                            height: 10
                            color: "transparent"
                        }

                        GridView{
                            id: diskGridView
                            width: parent.width - 20
                            height: parent.height - 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            model: rFileSystem.DiskDataList
                            cellWidth: width/3
                            cellHeight: 196
                            interactive: false

                            delegate: Rectangle{
                                id: diskGridViewDelegate
                                property real usedPercent: model.modelData.UsedVolumeSize/model.modelData.TotalVolumeSize
                                width: diskGridView.cellWidth
                                height: diskGridView.cellHeight
                                radius: 5
                                color: "transparent"

                                Column{
                                    width: parent.width - 20
                                    height: parent.height - 20
                                    anchors.centerIn: parent
                                    anchors.margins: 5

                                    Canvas{
                                        id: percentFilled
                                        property real center: height/2
                                        width: parent.width/2
                                        height: 100
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        antialiasing: true

                                        onPaint: {
                                            var ctx = getContext("2d");
                                            ctx.lineWidth = 5;
                                            ctx.strokeStyle = "#FFFFFF"

                                            ctx.beginPath();
                                            ctx.moveTo(center, center);
                                            ctx.fillStyle = "#90A4AE"
                                            ctx.arc(center, center, center - 10, 0, 2*Math.PI*diskGridViewDelegate.usedPercent);
                                            ctx.stroke();
                                            ctx.fill();
                                            ctx.closePath();

                                            ctx.beginPath();
                                            ctx.moveTo(center, center);
                                            ctx.fillStyle = "#1565C0"
                                            ctx.arc(center, center, center - 10, 2*Math.PI*diskGridViewDelegate.usedPercent, 2*Math.PI*(1 - diskGridViewDelegate.usedPercent));
                                            ctx.stroke();
                                            ctx.fill();
                                            ctx.closePath();
                                        }

                                        Text {
                                            anchors.fill: parent
                                            text: qsTr((1 - diskGridViewDelegate.usedPercent).toFixed(2)*100 + "%")
                                            font.bold: true
                                            font.pointSize: 12
                                            color: "#FFFFFF"
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: 25
                                        color: "transparent"
                                        Text {
                                            width: parent.width
                                            height: parent.height
                                            text: qsTr(model.modelData.DisplayName + " (" + model.modelData.DevName + ")")
                                            color: Qt.darker("grey")
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: 25
                                        color: "transparent"
                                        Text {
                                            width: parent.width
                                            height: parent.height
                                            text: qsTr(model.modelData.DiskUsageAnalysis)
                                            color: "grey"
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }

                                    Rectangle{
                                        width: parent.width
                                        height: 25
                                        color: "transparent"
                                        Text {
                                            width: parent.width
                                            height: parent.height
                                            text: qsTr(model.modelData.FileSystem + " File System")
                                            color: "grey"//
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                                    onClicked: diskGridView.currentIndex = index
                                    onDoubleClicked: rFileSystem.createNewTab(model.modelData.MountPoint)
                                }

                                Component.onCompleted: {
                                    diskCleanerCanvas.usedSpace += model.modelData.UsedVolumeSize
                                    diskCleanerCanvas.totalSpace += model.modelData.TotalVolumeSize
                                }
                            }

                            highlightFollowsCurrentItem: true
                            highlight: Rectangle{
                                width: parent.cellWidth - 10
                                height: parent.cellHeight - 10
                                color: rFileSystem.SelectedColor
                                opacity: 0.75
                                radius: 5
                            }
                        }
                    }
                }


                RectangularGlow{
                    anchors.fill: diskGridViewParentRect
                    glowRadius: 5
                    spread: 0.2
                    color: rFileSystem.BackgroundColor2
                    cornerRadius: diskGridViewParentRect.radius
                    z: -1
                }
            }


        }
    }
}
