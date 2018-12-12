import QtQuick 2.7
import QtQuick.Controls 2.2

Popup{
    id: notificationPanel
    property int oldY
    property int newY
    padding: 2
    modal: false

    Rectangle{
        id: notificationPanelParentRect
        width: parent.width
        height: parent.height
        color: rFileSystem.BackgroundColor
        border.width: 1
        Column{
            anchors.fill: parent
            Rectangle{
                id: headerRect
                width: parent.width
                height: parent.height*0.4
                color: "transparent"

                Rectangle{
                    anchors.fill: parent
                    opacity: 0.3
                    color: rFileSystem.HighlightColor
                }

                Text {
                    width: parent.width
                    height: parent.height
                    text: rFileSystem.NModel.Header
                    font.family: "Sans Serif"
                    color: rFileSystem.IconColor
                    clip: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    verticalAlignment: Text.AlignVCenter
                }
                RImageButton{
                    id: nmClosebtn
                    height: parent.height
                    width: height
                    anchors.right: parent.right
                    iconPath: "/local/Resources/icons-close.svg"
                    onClicked: notificationPanel.close()
                }
            }
            Rectangle{
                id: commentRect
                width: parent.width
                height: parent.height*0.6 - 2
                color: "transparent"
                Text {
                    width: parent.width
                    height: parent.height
                    text: rFileSystem.NModel.Comment
                    font.family: "Sans Serif"
                    color: rFileSystem.IconColor
                    clip: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    verticalAlignment: Text.AlignVCenter
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

    Connections{
        target: rFileSystem.NModel
        ignoreUnknownSignals: true
        onShowNotification: notificationPanel.open()
    }
}
