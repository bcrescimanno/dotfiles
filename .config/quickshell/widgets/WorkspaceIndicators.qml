import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.Config

RowLayout {
    id: root

    property color colOccupied: "#bd93f9"
    property color colActive: "#50fa7b"
    property color colEmpty: "#444b6a"
    property color colText: Style.colors.fg
    property color colBg: Style.colors.bg
    property string fontFamily: Style.fontFamily.nerd
    property int fontSize: Style.fontSize.normal
    property int workspaceCount: 10

    spacing: 4

    Repeater {
        model: root.workspaceCount

        delegate: Item {
            id: wsItem
            width: 28
            height: 28

            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool hasWindows: ws !== undefined

            Rectangle {
                id: wsButton
                anchors.centerIn: parent

                width: parent.isActive ? 28 : 24
                height: parent.isActive ? 28 : 24
                radius: Style.radius.normal

                Behavior on width {
                    NumberAnimation {
                        duration: Style.animationDuration.fast
                    }
                }
                Behavior on height {
                    NumberAnimation {
                        duration: Style.animationDuration.fast
                    }
                }

                color: parent.isActive ? root.colActive : parent.hasWindows ? Qt.rgba(root.colOccupied.r, root.colOccupied.g, root.colOccupied.b, 0.35) : "transparent"

                border.color: parent.isActive ? root.colActive : parent.hasWindows ? root.colOccupied : root.colEmpty
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: index + 1
                    color: wsItem.isActive ? root.colBg : root.colText
                    font.pixelSize: root.fontSize - 1
                    font.bold: wsItem.isActive
                    font.family: root.fontFamily
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }
}
