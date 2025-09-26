import QtQuick
import QtQml
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts

WrapperMouseArea {
    RowLayout {
        Text {
            id: osIcon
            height: parent.height
            text: "\u{f08c7}"
            color: "#f8f9f2"
            opacity: ArchService.numUpdates > 0 ? 1 : 0.5
            font.pixelSize: 24
            font.family: "JetBrainsMono Nerd Font"
            leftPadding: 10

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                }
            }
        }

        Text {
            id: updateCount
            color: "#f8f9f2"
            text: ArchService.numUpdates > 0 ? ArchService.numUpdates : ""
        }
    }
}
