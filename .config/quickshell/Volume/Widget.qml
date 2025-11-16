import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs.Config as Config
import qs.Modules as Modules

WrapperMouseArea {
    id: volumeWidget
    hoverEnabled: true

    implicitWidth: volumeIcon.implicitWidth
    implicitHeight: volumeIcon.implicitHeight

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var currentSink: Pipewire.defaultAudioSink

    Text {
        id: volumeIcon
        color: Config.Style.colors.fg
        font.family: Config.Style.fontFamily.icon
        font.pixelSize: Config.Style.fontSize.larger
        text: getVolumeIcon()
    }

    Modules.Tooltip {
        id: volumeLabel
        anchorTo: volumeWidget
        Text {
            id: volumeLabelText
            text: "Volume: " + Math.floor(currentSink.audio.volume * 100) + "%"
            color: Config.Style.colors.fg
        }
    }

    onWheel: event => {
        event.accepted = true;

        if (event.angleDelta.y < 0) {
            volumeDown();
        } else {
            volumeUp();
        }
    }

    onEntered: volumeLabel.open = true
    onExited: volumeLabel.open = false

    function getVolumeIcon(): string {
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
        if (currentSink && currentSink.isSink) {
            delta = Math.max(-100, Math.min(100, delta));
            delta = delta / 100;
            currentSink.audio.volume += delta;
        }
    }

    function volumeToEmoji(vol: real): string {
        vol = Math.max(0, Math.min(1, vol));

        if (vol === 0) {
            return "\ue04f";
        } else if (vol <= 0.25) {
            return "\ue04e";
        } else if (vol <= 0.50) {
            return "\ue04d";
        } else {
            return "\ue050";
        }
    }
}
