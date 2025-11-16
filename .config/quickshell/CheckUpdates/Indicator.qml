import QtQuick
import QtQml
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import qs.Config as Config
import qs.services

WrapperMouseArea {
    property var updateData: Updates.updateData

    RowLayout {
        Text {
            id: osIcon
            text: "\u{f08c7}"
            color: Config.Style.colors.fg
            opacity: updateData.length > 0 ? 1 : 0.5
            font.pixelSize: Config.Style.fontSize.larger
            font.family: Config.Style.fontFamily.nerd

            Behavior on opacity {
                NumberAnimation {
                    duration: Config.Style.animationDuration.fast
                    easing.type: Easing.OutCubic
                }
            }
        }

        Text {
            id: updateCount
            color: Config.Style.colors.fg
            font.pixelSize: Config.Style.fontSize.normal
            font.family: Config.Style.fontFamily.nerd
            opacity: updateData.length > 0 ? 1 : 0.5
            text: updateData.length > 0 ? updateData.length : ""

            Behavior on opacity {
                NumberAnimation {
                    duration: Config.Style.animationDuration.fast
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    hoverEnabled: true

    Component.onCompleted: () => {
        Updates.refresh();
    }
}
