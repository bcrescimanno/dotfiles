import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PopupWindow {
    id: mainWindow

    color: "transparent"

    implicitHeight: 500
    implicitWidth: 500

    property var updateData: []
    property var nextCheck: -1

    ClippingWrapperRectangle {
        color: "#ed282A36"
        anchors.fill: parent
        radius: 10
        ColumnLayout {
            id: testTable
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

            Rectangle {
                property bool hovered: false
                color: hovered ? "steelblue" : "darkblue"
                implicitWidth: children[0].implicitWidth
                implicitHeight: children[0].implicitHeight
                radius: 8
                RowLayout {
                    WrapperMouseArea {
                        hoverEnabled: true
                        Layout.margins: 10
                        Text {
                            anchors.fill: parent
                            text: "Refresh Updates "
                            color: "#ffffff"
                        }
                    }
                }
            }

            Text {
                text: nextCheck > -1 ? "Next Check at " + Qt.formatDateTime(nextCheck, "hh:mm:ss") : ""
            }
        }
    }
}
