import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.ArchUpdates as ArchUpdates

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    color: "transparent"

    default property alias left: leftPane.data
    property alias right: rightPane.data
    property alias center: centerPane.data

    Rectangle {
        color: "#000000"
        anchors.fill: parent

        radius: 10

        RowLayout {
            id: leftPane
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        RowLayout {
            id: centerPane
            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
        }

        RowLayout {
            id: rightPane
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
