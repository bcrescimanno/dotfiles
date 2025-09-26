import QtQuick
import QtQml
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts

PopupWindow {
    anchor.window: toplevel
    anchor.rect.y: toplevel.height - 2
    implicitWidth: 500
    implicitHeight: 500
    color: "transparent"

    Rectangle {
        color: "#ee282A36"
        anchors.fill: parent
        radius: 10

        ColumnLayout {
            spacing: 10
            Repeater {
                model: ArchService.updatesList

                Text {
                    Layout.leftMargin: 20
                    color: "#f8f9f2"
                    text: modelData
                }
            }
        }
    }
}
