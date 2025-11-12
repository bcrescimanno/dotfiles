import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

FloatingWindow {
    id: mainWindow

    color: "#ed282A36"

    property var updateData: []
    property var nextCheck: -1

    ClippingRectangle {
        color: "#00282A36"
        anchors.fill: parent
        anchors.margins: 10
        ColumnLayout {
            id: testTable
            spacing: 10
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            Repeater {
                model: updateData
                Item {

                    Layout.preferredHeight: updateName.implicitHeight
                    Layout.fillWidth: true

                    Text {
                        id: updateName
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pointSize: 13
                            family: "JetBrainsMono Nerd Font"
                            letterSpacing: 0
                        }
                        text: modelData.name
                        color: "#f8f8f2"
                    }
                    Text {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pointSize: 13
                            family: "JetBrainsMono Nerd Font"
                            letterSpacing: 0
                        }
                        text: modelData.version
                        color: "#f8f8f2"
                    }
                }
            }

            Rectangle {
                property bool hovered: false
                color: hovered ? "steelblue" : "darkblue"
                implicitWidth: children[0].implicitWidth
                implicitHeight: children[0].implicitHeight
                radius: 8
                RowLayout {
                    WrapperMouseArea {
                        hoverEnabled: true
                        onClicked: updateTimer.running = true
                        onEntered: parent.parent.hovered = true
                        onExited: parent.parent.hovered = false
                        Layout.margins: 10
                        Text {
                            anchors.fill: parent
                            text: "Refresh Updates " + updateData.length
                            color: "#ffffff"
                        }
                    }
                }
            }

            Text {
                text: nextCheck > -1 ? "Next Check at " + Qt.formatDateTime(nextCheck, "hh:mm:ss") : ""
            }
        }
    }

    Process {
        id: updateChecker
        command: ["checkupdates", "--nocolor"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: updateData = formatUpdates(this.text)
        }
    }

    Timer {
        id: updateTimer
        interval: 30000
        running: false
        repeat: false
        triggeredOnStart: true
        onTriggered: updateChecker.running = true
    }

    function formatUpdates(updates: string): var {
        // Side effects suck
        nextCheck = new Date(Date.now() + updateTimer.interval);

        return updates.trim().split("\n").map(update => {
            update = update.replace(/->/g, "→");
            let index = update.indexOf(" ");
            let name, version;

            if (index !== -1) {
                return {
                    name: update.substr(0, index),
                    version: update.substr(++index)
                };
            }
        });
    }
}
