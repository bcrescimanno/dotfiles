pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property var updateData: []
    property var nextCheck: -1
    property string test: "This is a test string"

    Process {
        id: checkupdates
        command: ['checkupdates', '--nocolor']

        onExited: exitCode => {
            if (exitCode === 0 || exitCode === 1) {
                updateData = formatUpdates(stdout.text);
            } else {
                console.error("Error when checking for updates");
            }
        }

        stdout: StdioCollector {}
    }

    Timer {
        id: updateTimer
        interval: 10000
        running: false
        repeat: false
        triggeredOnStart: true
        onTriggered: checkupdates.running = true
    }

    function checkUpdates() {
        if (!checkupdates.running) {
            checkupdates.running = true;
        }
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
