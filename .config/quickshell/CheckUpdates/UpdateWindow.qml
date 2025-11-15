import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.Config as Config

PopupWindow {
    id: mainWindow

    color: "transparent"

    // TODO: Use a Layout to make this automatic?
    // TODO: is there a maximum height?
    implicitHeight: updatesTable.implicitHeight + updatesTable.anchors.margins * 2
    implicitWidth: updatesTable.implicitWidth + updatesTable.anchors.margins * 2

    property var updateData: []
    property var nextCheck: -1
    property bool opened: false

    onOpenedChanged: if (opened)
        visible = true

    ClippingWrapperRectangle {
        color: Config.Style.colors.bg
        anchors.fill: parent
        radius: Config.Style.radius.normal
        opacity: mainWindow.opened ? 1 : 0
        scale: mainWindow.opened ? 1 : 0.8

        onOpacityChanged: {
            if (!mainWindow.opened && opacity === 0) {
                mainWindow.visible = false;
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Config.Style.animationDuration.normal
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: Config.Style.animationDuration.normal
                easing.type: Easing.OutBack
            }
        }

        ColumnLayout {
            id: updatesTable
            anchors.margins: 10
            anchors.fill: parent
            spacing: 10

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            Repeater {
                model: updateData

                Item {

                    Layout.preferredHeight: updateName.implicitHeight
                    // TODO: don't hard code a gap here
                    Layout.preferredWidth: updateName.implicitWidth + updateVersion.implicitWidth + 50
                    Layout.fillWidth: true

                    Text {
                        id: updateName
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pixelSize: Config.Style.fontSize.normal
                            family: Config.Style.fontFamily.mono
                        }
                        text: modelData.name
                        color: Config.Style.colors.fg
                    }
                    Text {
                        id: updateVersion
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pixelSize: Config.Style.fontSize.normal
                            family: Config.Style.fontFamily.mono
                        }
                        text: modelData.version
                        color: Config.Style.colors.fg
                    }
                }
            }
        }
    }
}
