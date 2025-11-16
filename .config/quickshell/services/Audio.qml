pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: !!sink?.audio?.muted

    function setVolume(newVolume: real): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.volume = Math.max(0, Math.min(1, newVolume));
        }
    }

    function volumeUp(): void {
        setVolume(volume + 0.03);
    }

    function volumeDown(): void {
        setVolume(volume - 0.03);
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
}
