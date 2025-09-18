import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick

Scope {
  id: topBar

  PanelWindow {
    anchors {
      top: true
      left: true
      right: true
    }

    implicitHeight: 30
    color: "transparent"

    margins {
      top: 20
      left: 20
      right: 20
    }

    Rectangle {
      anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        bottom: parent.bottom
      }

      radius: 10
      color: "#cc282A36"

      Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        spacing: 8

        Repeater {
          model: SystemTray.items

          delegate: Item {
            width: 16
            height: 16

            IconImage {
              anchors.fill: parent
              source: modelData.icon
            }

            MouseArea {
              anchors.fill: parent
              onClicked: {
                modelData.activate()
              }
            }
          }
        }
      }
    }
  }
}
