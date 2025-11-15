import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

WrapperMouseArea {

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var currentSink: Pipewire.defaultAudioSink

    Text {
        color: "#f8f8f2"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 24
        text: getVolume()
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

    function getVolume(): string {
        if (currentSink && currentSink.isSink) {
            return volumeToEmoji(currentSink.audio.volume);
        }

        return "Invalid Sink";
    }

    function volumeUp() {
        setVolume(2);
    }

    function volumeDown() {
        setVolume(-2);
    }

    function setVolume(delta: int): void {
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
