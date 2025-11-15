import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Text {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var currentSink: Pipewire.defaultAudioSink

    color: "#f8f8f2"
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 24
    text: getVolume()

    function getVolume(): string {
        if (currentSink && currentSink.isSink) {
            return volumeToEmoji(currentSink.audio.volume);
        }

        return "Invalid Sink";
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
