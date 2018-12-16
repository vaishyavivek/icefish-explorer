import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4
import QtQuick.Window 2.10
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12


ApplicationWindow{
    width: 400
    height: 800
    visible: true
    color: "grey"

    Rectangle{
        id: rectangle
        width: 300
        height: 400
        color: "#3a3b3f"

        Column{
            id: columnLayout
            anchors.fill: parent
            spacing: 10


            Switch {
                id: element
                text: qsTr("Connect")
            }

            Rectangle{
                width: parent.width
                height: 200
                ScrollView{
                    id: scrollView
                    anchors.fill: parent

                    TextArea {
                        id: textAreadd
                        width: parent.width
                        height: parent.height
                        background: Rectangle {
                            Layout.maximumHeight: 350
                        }

                        text: qsTr("Waiting...")
                        wrapMode: Text.WrapAnywhere
                        horizontalAlignment: Text.AlignLeft
                    }
                }
            }
        }
    }
}


