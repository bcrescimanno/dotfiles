import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 20

    Repeater {
        model: SystemTray.items

        WrapperMouseArea {
            acceptedButtons: Qt.AllButtons
            IconImage {
                implicitHeight: 16
                implicitWidth: 16
                anchors.fill: parent
                source: modelData.icon
            }
            onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    modelData.activate();
                    return;
                }
                if (event.button === Qt.RightButton) {
                    // TODO: Handle the menu for tray items
                    return;
                }
            }
        }
    }
}
