import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Config as Config

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
    property alias backgroundColor: background.color

    Rectangle {
        id: background
        anchors.fill: parent

        radius: Config.Style.radius.normal

        RowLayout {
            id: leftPane
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20
        }

        RowLayout {
            id: centerPane
            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20
        }

        RowLayout {
            id: rightPane
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20
        }
    }
}
