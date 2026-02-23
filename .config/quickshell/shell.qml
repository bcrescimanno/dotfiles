//@ pragma UseQApplication
import Quickshell
import Quickshell.Wayland
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

        focusable: true

        left: [
            CheckUpdates.Indicator {
                id: updatesIndicator
                focus: true
                onClicked: () => {
                    if (updateData.length > 0) {
                        archUpdates.opened = !archUpdates.opened;
                    } else {
                        Updates.refresh();
                    }
                }

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        if (archUpdates.opened) {
                            archUpdates.opened = false;
                        }
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
