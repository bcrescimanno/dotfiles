import Quickshell
import QtQuick
import qs.ArchUpdates as ArchUpdates

ShellRoot {
    TopPanel {
        margins {
            top: 10
            left: 20
            right: 20
        }

        implicitHeight: 40

        backgroundColor: "#ed282A36"

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }

        right: [
            Text {
                id: clockView
                text: Qt.formatDateTime(clock.date, "h:mm ap")
                color: "#f8f8f2"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
            }
        ]
    }

    LazyLoader {
        ArchUpdates.UpdateWindow {}
    }
}
