pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property var updateData: []
    property var nextCheck: new Date()
    property bool hasRun: false

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
        // TODO: Why is this delay required?
        interval: hasRun ? (3600 * 1000) : 1000
        running: false
        repeat: true
        onTriggered: () => {
            hasRun = true;
            checkupdates.running = true;
        }
    }

    function refresh() {
        if (!updateTimer.running) {
            updateTimer.running = true;
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
