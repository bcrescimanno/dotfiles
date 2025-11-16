import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.CheckUpdates as CheckUpdates
import qs.SystemTray as SystemTray
import qs.services
import qs.widgets as Widgets

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
            Widgets.Volume {},
            SystemTray.Widget {},
            Widgets.Weather {},
            Widgets.Clock {}
        ]
    }
}
