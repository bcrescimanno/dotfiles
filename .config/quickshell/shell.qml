import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import qs.CheckUpdates as CheckUpdates

Scope {
    id: topBar

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    PanelWindow {
        id: toplevel
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 40
        color: "transparent"

        margins {
            top: 10
            left: 20
            right: 20
        }

        // Renders the main panel
        Rectangle {
            anchors.fill: parent
            radius: 10
            color: "#cc282A36"

            // Left side
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                spacing: 24

                WrapperMouseArea {
                    Text {
                        id: arch
                        text: "\u{f08c7}"
                        color: "#f8f9f2ff"
                        font.pixelSize: 24
                        font.family: "JetBrainsMono Nerd Font"
                        leftPadding: 20
                    }
                    onClicked: CheckUpdates.ArchService.checkForUpdates()
                }

                Text {
                    text: CheckUpdates.ArchService.updatesList.length
                }
            }

            // Right side?
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                spacing: 24
                Row {
                    spacing: 12
                    Repeater {
                        model: SystemTray.items

                        Item {
                            width: 16
                            height: 16

                            IconImage {
                                anchors.fill: parent
                                source: modelData.icon
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    modelData.activate();
                                }
                            }
                        }
                    }
                }

                Item {
                    id: textBox
                    Layout.fillWidth: true
                    height: sample.implicitHeight
                    width: fixedWidth
                    Layout.rightMargin: 20

                    property int fixedWidth: sample.implicitWidth

                    // TODO: Fix the am/pm showing relative to the rest of the string
                    // It's hard to see without the seconds--but it's definitely a thing
                    // It also doesn't happen with a fixed-width font...
                    Text {
                        id: sample
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 16
                        color: "#f8f9f2ff"
                        width: textBox.fixedWidth
                        text: Qt.formatDateTime(clock.date, "MMM dd h:mm ap")
                    }
                }
            }
        }
    }
}
