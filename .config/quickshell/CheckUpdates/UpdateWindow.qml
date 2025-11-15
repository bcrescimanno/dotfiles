import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

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
        color: "#ed282A36"
        anchors.fill: parent
        radius: 10
        opacity: mainWindow.opened ? 1 : 0
        scale: mainWindow.opened ? 1 : 0.8

        onOpacityChanged: {
            if (!mainWindow.opened && opacity === 0) {
                mainWindow.visible = false;
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 250
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
                            pixelSize: 16
                            family: "JetBrainsMono Nerd Font"
                        }
                        text: modelData.name
                        color: "#f8f8f2"
                    }
                    Text {
                        id: updateVersion
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pixelSize: 16
                            family: "JetBrainsMono Nerd Font"
                        }
                        text: modelData.version
                        color: "#f8f8f2"
                    }
                }
            }
        }
    }
}
