import QtQuick 2.7
import QtQuick.Controls 2.2

ToolTip{
    id: rmenu
    property bool isOpened: false
    property int actionMenuCount: 0
    property string filePath
    property variant menuList
    padding: 0
    contentHeight: actionMenuCount*29
    contentWidth: 200
    background: Rectangle{
        opacity: 0.3
        color: rFileSystem.BackgroundColor1
    }

    Rectangle{
        anchors.fill: parent
        color: rFileSystem.BackgroundColor1
        border.color: rFileSystem.IconColor1
        border.width: 1
        radius: 5

        ListView{
            id: menuListView
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent
            spacing: 3
            model: menuList

            delegate: RTextButton{
                width: menuListView.width
                height: 25
                text: (model.modelData.HasSubmenu ? "<    ": "      ")  + model.modelData.ServiceName
                alignTextCenter: false
                onClicked: {
                    if(model.modelData.HasSubmenu)
                        submenuPopup.open()
                    else{
                        var action = model.modelData.Action
                        if(action === "newtab")
                            rFileSystem.createNewTab(filePath)
                        else
                            qtModel.performAction(filePath, action)
                        rmenu.close()
                    }
                }

                ToolTip{
                    id: submenuPopup
                    property bool isOpened: false
                    property string action: model.modelData.Action
                    property variant subMenuModel: model.modelData.Submenu
                    padding: 0
                    contentWidth: 200
                    contentHeight: (model.modelData.SubmenuCount)*29
                    x: parent.x - 202
                    y: parent.y
                    background: Rectangle{
                        opacity: 0.3
                        color: rFileSystem.BackgroundColor1
                    }

                    Rectangle{
                        anchors.fill: parent
                        color: rFileSystem.BackgroundColor1
                        border.color: rFileSystem.IconColor1
                        border.width: 1
                        radius: 5

                        ListView{
                            id: submenuListView
                            width: parent.width - 10
                            height: parent.height - 10
                            anchors.centerIn: parent
                            spacing: 3
                            model: submenuPopup.subMenuModel

                            delegate: RImageExpandingButton{
                                width: submenuListView.width
                                height: 25
                                icon.source: model.modelData.ServiceIcon
                                text: model.modelData.ServiceName
                                onClicked: {
                                    qtModel.performAction(filePath, submenuPopup.action, model.modelData.DesktopFile)
                                    submenuPopup.close()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    onClosed: isOpened = false
}
