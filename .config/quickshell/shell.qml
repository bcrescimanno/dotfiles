import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import qs.CheckUpdates as CheckUpdates

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
                        archUpdates.visible = !archUpdates.visible;
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
            Text {
                id: weatherWidget
                text: ""
                color: "#f8f8f2"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16

                Process {
                    running: true
                    command: ['/home/brian/dotfiles/.config/bin/weather.sh']
                    stdout: StdioCollector {
                        onStreamFinished: weatherWidget.text = JSON.parse(this.text).text
                    }
                }
            },
            RowLayout {
                id: systemTray
                spacing: 10
                Repeater {
                    model: SystemTray.items

                    WrapperMouseArea {
                        acceptedButtons: Qt.AllButtons
                        IconImage {
                            implicitHeight: 16
                            implicitWidth: 16
                            anchors.fill: parent
                            source: modelData.icon
                        }
                        onClicked: event => {
                            if (event.button === Qt.LeftButton) {
                                modelData.activate();
                                return;
                            }
                            if (event.button === Qt.RightButton) {
                                // TODO: Handle the menu for tray items
                                return;
                            }
                        }
                    }
                }
            },
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
