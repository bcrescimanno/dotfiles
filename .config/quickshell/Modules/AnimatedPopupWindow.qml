import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Config as Config

PopupWindow {
    id: root
    visible: false
    color: "transparent"

    implicitWidth: body.implicitWidth
    implicitHeight: body.implicitHeight

    property bool open: false
    property bool opened: false
    property int delay: 0
    property int speed: Config.Style.animationDuration.normal

    default property alias content: body.children

    property alias topMargin: body.topMargin
    property alias bottomMargin: body.bottomMargin
    property alias leftMargin: body.leftMargin
    property alias rightMargin: body.rightMargin
    property alias border: body.border

    onOpenChanged: showTimer.running = true

    onOpenedChanged: {
        if (opened) {
            visible = true;
        }
    }

    Timer {
        id: showTimer
        interval: delay
        repeat: false
        running: false
        onTriggered: opened = open
    }

    ClippingWrapperRectangle {
        id: body
        color: Config.Style.colors.bg
        anchors.fill: parent

        opacity: root.opened ? 1 : 0
        scale: root.opened ? 1 : 0.8
        radius: Config.Style.radius.normal

        onOpacityChanged: {
            if (!root.opened && opacity === 0) {
                root.visible = false;
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: speed
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: speed
                easing.type: Easing.OutBack
            }
        }
    }
}
