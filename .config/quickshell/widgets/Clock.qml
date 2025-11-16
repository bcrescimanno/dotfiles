import Quickshell
import Quickshell.Widgets
import QtQuick
import qs.services
import qs.Config
import qs.Modules

WrapperMouseArea {
    id: clockWidget

    hoverEnabled: true
    implicitWidth: clockText.implicitWidth
    implicitHeight: clockText.implicitHeight

    Text {
        id: clockText
        text: Time.format("h:mm ap")
        color: Style.colors.fg
        font.family: Style.fontFamily.mono
        font.pixelSize: Style.fontSize.normal
    }
    Tooltip {
        id: dateTip
        anchorTo: clockWidget
        Text {
            text: Time.format("dddd MMMM d, yyyy")
            color: Style.colors.fg
            font.family: Style.fontFamily.mono
        }
    }

    onEntered: dateTip.open = true
    onExited: dateTip.open = false
}
