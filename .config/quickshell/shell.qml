import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.CheckUpdates as CheckUpdates
import qs.Weather as Weather
import qs.SystemTray as SystemTray

import Quickshell.Io

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
            CheckUpdates.Indicator {
                id: updatesIndicator
                onClicked: () => {
                    if (updateData.length > 0) {
                        archUpdates.opened = !archUpdates.opened;
                    }
                }
                CheckUpdates.UpdateWindow {
                    id: archUpdates
                    updateData: updatesIndicator.updateData
                    anchor.window: topPanel
                    anchor.rect.y: 40
                }
            }
        ]

        right: [
            SystemTray.Widget {},
            Weather.WeatherWidget {},
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
