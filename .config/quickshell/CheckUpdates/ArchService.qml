pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var updatesList: []
    property int numUpdates: 0
    property bool hasRun: false

    Process {
        id: updateScript
        command: ['checkupdates']

        onExited: exitCode => {
            if (exitCode === 0 || exitCode === 1) {
                parseUpdates(stdout.text);
            } else {
                console.error("Error when checking for updates");
            }
        }

        stdout: StdioCollector {}
    }

    Timer {
        // TODO: Understand why this can't run in advance
        // TODO: make configurable
        interval: hasRun ? 3600000 : 1000
        running: true
        repeat: false
        onTriggered: checkForUpdates()
    }

    function checkForUpdates() {
        hasRun = true;
        updateScript.running = true;
    }

    function parseUpdates(text: string) {
        if (text) {
            updatesList = text.trim().split("\n");
            numUpdates = updatesList.length;
        } else {
            console.log("Zero updates found");
        }
    }
}
