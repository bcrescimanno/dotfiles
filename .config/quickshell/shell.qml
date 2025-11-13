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

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }

        right: [
            Text {
                id: clockView
                text: Qt.formatDateTime(clock.date, "h:mm ap")
                color: "#ffffff"
                font.pixelSize: 16
            }
        ]
    }

    LazyLoader {
        ArchUpdates.UpdateWindow {}
    }
}
