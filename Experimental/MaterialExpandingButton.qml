import QtQuick 2.7
import QtQuick.Controls 2.2

Rectangle{
    id: materialExpandingButton
    readonly property string highlightColor: "lightblue"
    readonly property string selectedColor: "skyblue"
    property string iconPath: ""
    property string content: ""
    property bool checked: false
    signal clicked

    color: "transparent"

    Row{
        anchors.fill: parent
        Rectangle{
            id: materialButton
            width: parent.height
            height: parent.height
            color: "transparent"

            Image {
                source: iconPath
                sourceSize.width: parent.width*0.75
                sourceSize.height: parent.height*0.75
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                hoverEnabled: true
                onEntered: {
                    if(!checked)
                        mouseEnteredAnimation.start()
                }
                onExited: {
                    if(!checked)
                        mouseExitedAnimation.start()
                }
                onClicked: {
                    checked = true
                    materialExpandingButton.clicked()
                }
            }

            PropertyAnimation{
                id: mouseEnteredAnimation
                target: materialButton
                property: "color"
                to: highlightColor
                duration: 500
            }
            PropertyAnimation{
                id: mouseExitedAnimation
                target: materialButton
                property: "color"
                to: "transparent"
                duration: 500
            }
        }

        Rectangle{
            width: parent.width - materialButton.width
            height: parent.height
            clip: true
            color: "transparent"
            visible: (width >= 1)
            Text {
                text: content
                font.pointSize: 12
                verticalAlignment: Text.AlignVCenter
                width: parent.width
                height: parent.height
                //wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                clip: true
            }
        }
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        z: -1
        onEntered: {
            if(!checked)
                mouseEnteredAnimationMain.start()
        }
        onExited: {
            if(!checked)
                mouseExitedAnimationMain.start()
        }
        onClicked: {
            checked = true
            materialExpandingButton.clicked()
        }

    }

    PropertyAnimation{
        id: mouseEnteredAnimationMain
        target: materialExpandingButton
        property: "color"
        to: highlightColor
        duration: 500
    }
    PropertyAnimation{
        id: mouseExitedAnimationMain
        target: materialExpandingButton
        property: "color"
        to: "transparent"
        duration: 500
    }

    PropertyAnimation{
        id: selectedAnimation
        target: materialExpandingButton
        property: "color"
        to: selectedColor
        duration: 500
    }

    onCheckedChanged: {
        if(checked)
            selectedAnimation.start()
    }
}
