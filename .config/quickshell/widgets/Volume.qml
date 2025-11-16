import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs.Config as Config
import qs.Modules as Modules
import qs.services

WrapperMouseArea {
    id: volumeWidget
    hoverEnabled: true

    implicitWidth: volumeIcon.implicitWidth
    implicitHeight: volumeIcon.implicitHeight

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
            text: "Volume: " + getVolumePercent()
            color: Config.Style.colors.fg
        }
    }

    onWheel: event => {
        event.accepted = true;

        if (event.angleDelta.y < 0) {
            Audio.volumeDown();
        } else {
            Audio.volumeUp();
        }
    }

    onEntered: volumeLabel.open = true
    onExited: volumeLabel.open = false

    function getVolumeIcon(): string {
        let vol = Audio.volume;

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

    function getVolumePercent(): string {
        return Math.round(Audio.volume * 100) + "%"
    }
}
