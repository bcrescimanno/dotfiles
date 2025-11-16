import QtQuick
import Quickshell
import Quickshell.Io
import qs.Config as Config

Item {
    id: weatherWidget
    property string text: ""

    implicitWidth: children[0].implicitWidth
    implicitHeight: children[0].implicitHeight

    Text {
        text: weatherWidget.text
        color: Config.Style.colors.fg
        font.family: Config.Style.fontFamily.sans
        font.pixelSize: Config.Style.fontSize.normal
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
