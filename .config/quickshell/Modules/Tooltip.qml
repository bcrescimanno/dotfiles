import QtQuick
import Quickshell
import qs.Config as Config

AnimatedPopupWindow {
    topMargin: 10
    rightMargin: 20
    bottomMargin: 10
    leftMargin: 20
    speed: Config.Style.animationDuration.fast
    delay: 250

    property Item anchorTo

    border {
        color: "#eed6acff"
        width: 2
    }

    anchor {
        item: anchorTo
        rect {
            y: anchorTo.implicitHeight
        }
    }
}
