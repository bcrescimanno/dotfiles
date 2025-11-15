import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs.Util as Util

WrapperMouseArea {
    id: volumeWidget
    hoverEnabled: true

    implicitWidth: volumeIcon.implicitWidth
    implicitHeight: volumeIcon.implicitHeight

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var currentSink: Pipewire.defaultAudioSink
    property real tooltipX: 0
    property real tooltipY: 0

    Text {
        id: volumeIcon
        color: "#f8f8f2"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 24
        text: getVolume()
    }

    PopupWindow {
        id: volumeLabel
        visible: false
        color: "transparent"
        implicitWidth: testwrap.implicitWidth
        implicitHeight: testwrap.implicitHeight
        WrapperRectangle {
            id: testwrap
            topMargin: 10
            bottomMargin: 10
            leftMargin: 20
            rightMargin: 20
            color: "#ed282a36"
            radius: 8
            border {
                color: "#eed6acff"
                width: 2
            }
            Text {
                id: volumeLabelText
                text: "Volume: " + Math.floor(currentSink.audio.volume * 100) + "%"
                color: "#f8f8f2"
            }
        }
        anchor {
            item: volumeWidget
            rect {
                y: tooltipY
                x: tooltipX
            }
        }
    }

    onWheel: event => {
        event.accepted = true;

        let distance = event.angleDelta.y;

        if (distance < 0) {
            volumeDown();
        } else {
            volumeUp();
        }
    }

    onEntered: event => {
        volumeLabel.visible = true;
    }

    onExited: event => {
        volumeLabel.visible = false;
    }

    onPositionChanged: event => {
        tooltipX = event.x + 5;
        tooltipY = event.y + 10;
    }

    function getVolume(): string {
        if (currentSink && currentSink.isSink) {
            return volumeToEmoji(currentSink.audio.volume);
        }

        return "";
    }

    function volumeUp(): void {
        setVolume(3);
    }

    function volumeDown(): void {
        setVolume(-3);
    }

    function setVolume(delta: int): void {
        delta = Math.max(-100, Math.min(100, delta));
        delta = delta / 100;
        if (currentSink && currentSink.isSink) {
            currentSink.audio.volume += delta;
        }
    }

    function volumeToEmoji(vol: real): string {
        vol = Math.max(0, Math.min(1, vol));

        if (vol === 0) {
            return "\u{f0581}";
        } else if (vol <= 0.33) {
            return "\u{f057f}";
        } else if (vol <= 0.66) {
            return "\u{f0580}";
        } else {
            return "\u{f057e}";
        }
    }
}
