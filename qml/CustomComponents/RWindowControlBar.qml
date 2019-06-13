import QtQuick 2.0

Rectangle{
    id: windowControlBar
    width: height*3 + 4
    height: 35
    anchors.verticalCenter: parent.verticalCenter
    color: "transparent"
    Row{
        anchors.fill: parent
        anchors.margins: 2
        RImageButton{
            id: minimizeWindowBtn
            height: parent.height
            width: height
            hoverText: "Minimize"
            icon.source: "/local/assets/window-minimize.svg"
            icon.color: rFileSystem.IconColor
            onClicked: showMinimized()
        }
        RImageButton{
            id: maximizeWindowBtn
            property bool windowState: false
            height: parent.height
            width: height
            hoverText: "Full Window"
            icon.source: "/local/assets/window-full.svg"
            icon.color: rFileSystem.IconColor
            onClicked: {
                if(windowState){
                    showNormal()
                    icon.source = "/local/assets/window-full.svg"
                }
                else{
                    showMaximized()
                    icon.source= "/local/assets/window-half.svg"
                }
                windowState = !windowState
            }
        }
        RImageButton{
            id: closeWindowBtn
            height: parent.height
            width: height
            hoverText: "Close"
            icon.source: "/local/assets/window-close.svg"
            icon.color: "#F80808"
            onClicked: Qt.quit()
        }
    }
}
