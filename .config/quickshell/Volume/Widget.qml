import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Text {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    color: "#f8f8f2"
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 24
    text: volumeToEmoji(getVolume(Pipewire.defaultAudioSink))

    function getVolume(sink) {
        if (sink && sink.isSink) {
            return sink.audio.volume;
        }
    }

    function volumeToEmoji(vol) {
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
