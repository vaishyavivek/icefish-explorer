import QtQuick 2.8
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Component{
    GridView{
        id: fileFolderGridView

        property bool editing: false
        property int iconWidth: scaleFactor
    }
}


