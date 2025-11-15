import QtQuick
import Quickshell
import Quickshell.Io

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
}
