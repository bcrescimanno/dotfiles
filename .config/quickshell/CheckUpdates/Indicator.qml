import QtQuick
import QtQml
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts

WrapperMouseArea {
    property var updateData: ArchService.updateData

    RowLayout {
        Text {
            id: osIcon
            text: "\u{f08c7}"
            color: "#f8f9f2"
            opacity: updateData.length > 0 ? 1 : 0.5
            font.pixelSize: 24
            font.family: "JetBrainsMono Nerd Font"

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                }
            }
        }

        Text {
            id: updateCount
            color: "#f8f9f2"
            font.pixelSize: 16
            font.family: "JetBrainsMono Nerd Font"
            opacity: updateData.length > 0 ? 1 : 0.5
            text: updateData.length > 0 ? updateData.length : ""

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                }
            }
        }
    }

    hoverEnabled: true

    Component.onCompleted: () => {
        ArchService.checkUpdates();
    }
}
