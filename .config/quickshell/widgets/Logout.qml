import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import qs.Config
import qs.Modules

WrapperMouseArea {
    cursorShape: Qt.PointingHandCursor

    Text {
        color: Style.colors.fg
        font {
            family: Style.fontFamily.icon
            pixelSize: Style.fontSize.large
        }
        text: "\ue9ba"
    }

    Process {
        id: wleave
        command: ['uwsm', 'app', '--', 'wleave']
        running: false
    }

    onClicked: wleave.running = true
}
