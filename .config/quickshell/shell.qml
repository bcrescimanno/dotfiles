import Quickshell
import Quickshell.Widgets
import QtQuick
import qs.ArchUpdates as ArchUpdates

ShellRoot {
    TopPanel {
        id: topPanel
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

        left: [
            WrapperMouseArea {
                Text {
                    text: "󰣇"
                    color: "#f8f8f2"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 24
                }

                onClicked: () => {
                    console.log(updatesLoader.item.updateData[0]);
                    updatesLoader.loading = true;
                    updatesLoader.item.visible = !updatesLoader.item.visible;
                }
            },
            LazyLoader {
                id: updatesLoader
                loading: true
                ArchUpdates.UpdateWindow {
                    id: archUpdates
                    anchor.window: topPanel
                    anchor.rect.y: 40
                }
            }
        ]

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
}
