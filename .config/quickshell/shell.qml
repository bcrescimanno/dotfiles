//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.CheckUpdates as CheckUpdates
import qs.services
import qs.widgets as Widgets

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
                    } else {
                        Updates.refresh();
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
            Widgets.SystemTray {},
            Widgets.Weather {},
            Widgets.Clock {},
            Widgets.Logout {}
        ]
    }
}
