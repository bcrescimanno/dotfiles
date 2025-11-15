import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PopupWindow {
    id: mainWindow

    color: "transparent"

    // TODO: Use a Layout to make this automatic?
    implicitHeight: updatesTable.implicitHeight + updatesTable.anchors.margins * 2
    implicitWidth: updatesTable.implicitWidth + updatesTable.anchors.margins * 2

    property var updateData: []
    property var nextCheck: -1

    ClippingWrapperRectangle {
        color: "#ed282A36"
        anchors.fill: parent
        radius: 10
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
                    Layout.preferredWidth: updateName.implicitWidth + updateVersion.implicitWidth + 30
                    Layout.fillWidth: true

                    Text {
                        id: updateName
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pixelSize: 14
                            family: "JetBrainsMono Nerd Font"
                            letterSpacing: 0
                        }
                        text: modelData.name
                        color: "#f8f8f2"
                    }
                    Text {
                        id: updateVersion
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pixelSize: 14
                            family: "JetBrainsMono Nerd Font"
                            letterSpacing: 0
                        }
                        text: modelData.version
                        color: "#f8f8f2"
                    }
                }
            }
        }
    }
}
