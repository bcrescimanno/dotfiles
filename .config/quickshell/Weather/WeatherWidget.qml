import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: weatherWidget
    property string text: ""

    implicitWidth: children[0].implicitWidth
    implicitHeight: children[0].implicitHeight

    Text {
        text: weatherWidget.text
        color: "#f8f8f2"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 16
    }

    Timer {
        running: true
        interval: 15 * 60 * 1000
        triggeredOnStart: true
        onTriggered: weatherChecker.running = true
    }

    Process {
        id: weatherChecker
        running: false
        command: ['/home/brian/dotfiles/.config/bin/weather.sh']
        stdout: StdioCollector {
            onStreamFinished: weatherWidget.text = JSON.parse(this.text).text
        }
    }
}
