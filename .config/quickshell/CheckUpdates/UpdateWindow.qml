import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.Config as Config
import qs.Modules as Modules

Modules.AnimatedPopupWindow {
    id: mainWindow

    property var updateData: []
    property var nextCheck: ArchService.nextCheck

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

        Text {
            color: Config.Style.colors.fg
            font {
                family: Config.Style.fontFamily.sans
                pixelSize: Config.Style.fontSize.normal
            }
            text: "Next update at " + Qt.formatDateTime(nextCheck, "h:mm ap")
        }
    }
}
