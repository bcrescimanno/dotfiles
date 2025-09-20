pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var updatesList: []

    Process {
        id: updateScript
        command: ['checkupdates']

        onExited: exitCode => {
            console.log("Attempting to get updates...");
            if (exitCode === 0 || exitCode === 1) {
                parseUpdates(stdout.text);
            } else {
                console.log("Error when checking for updates");
            }
        }

        stdout: StdioCollector {}
    }

    function checkForUpdates() {
        updateScript.running = true;
    }

    function parseUpdates(text) {
        if (text) {
            updatesList = text.split("\n");
            console.log("There are " + updatesList.length + " updates");
        }
    }
}
