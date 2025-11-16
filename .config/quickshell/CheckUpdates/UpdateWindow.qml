import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Config as Config
import qs.Modules as Modules
import qs.services

Modules.AnimatedPopupWindow {
    id: mainWindow

    property var updateData: []
    property var lastCheck: Updates.lastCheck

    onLastCheckChanged: {
        loadingIndicator.stop();
        let current = refreshButton.rotation % -360;
        if (current > 0)
            current -= 360;

        let goal = Math.abs(current - -180) < (Math.abs(current - -360)) ? -180 : -360;

        let distance = Math.abs(current - goal);
        let duration = (distance / 360) * 1000;

        loadingLander.duration = duration;
        loadingLander.from = current;
        loadingLander.to = goal;
        loadingLander.start();
    }

    topMargin: 10
    rightMargin: 20
    bottomMargin: 10
    leftMargin: 20

    ColumnLayout {
        id: updatesTable
        spacing: 10

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
                        bold: true
                        pixelSize: Config.Style.fontSize.normal
                        family: Config.Style.fontFamily.sans
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
                        family: Config.Style.fontFamily.sans
                    }
                    text: modelData.version
                    color: Config.Style.colors.fg
                }
            }
        }

        Item {
            Layout.preferredHeight: refreshButton.implicitHeight
            Layout.fillWidth: true
            Text {
                color: Config.Style.colors.fg
                anchors.verticalCenter: parent.verticalCenter
                font {
                    family: Config.Style.fontFamily.sans
                    pixelSize: Config.Style.fontSize.normal
                }
                text: "Last updated: " + Qt.formatDateTime(lastCheck, "h:mm ap")
            }

            WrapperMouseArea {
                id: refreshButton
                anchors.right: parent.right

                Text {
                    anchors.right: parent.right
                    color: Config.Style.colors.fg
                    font {
                        family: Config.Style.fontFamily.icon
                        pixelSize: Config.Style.fontSize.larger
                    }
                    text: "\ue627"
                }

                NumberAnimation on rotation {
                    id: loadingIndicator
                    from: 0
                    to: -360
                    duration: 1000
                    loops: Animation.Infinite
                    running: false
                }

                NumberAnimation {
                    id: loadingLander
                    target: refreshButton
                    property: "rotation"
                }
                onClicked: {
                    if (!loadingIndicator.running) {
                        Updates.refresh();
                        loadingIndicator.start();
                    }
                }
            }
        }
    }
}
