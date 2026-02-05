// VerticalBarContent.qml
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    anchors.fill: parent
		property color backgroundColor: "#000000"
		property color primaryColor: "#000000"
		property color secondaryColor: "#000000"

    // Clock
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Top spacer
        ColumnLayout {
            Layout.topMargin: 12
            Layout.fillWidth: true
						Layout.alignment: Qt.AlignHCenter

						RadialVolume {}
						RadialBattery {}
						NotificationCounter {
							backgroundColor: root.backgroundColor
							primaryColor: root.primaryColor
							secondaryColor: root.secondaryColor
						}
        }

        // Middle section (fills space)
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Bottom section (clock + volume)
        ColumnLayout {
            Layout.bottomMargin: 12
            Layout.fillWidth: true
            spacing: 2

            // Clock HH/MM
            Text {
                color: secondaryColor
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDateTime(clock.date, "HH")
                font.pixelSize: 16
            }

            Text {
                color: secondaryColor
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDateTime(clock.date, "mm")
                font.pixelSize: 16
                Layout.bottomMargin: 6
            }

            // Date dd/MM
            Text {
                color: secondaryColor
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDateTime(clock.date, "dd/MM")
                font.pixelSize: 8
            }

            // Day of week
            Text {
                color: secondaryColor
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 8

                text: {
                    const youbi = ["日", "月", "火", "水", "木", "金", "土"]
                    return youbi[clock.date.getDay()] + "曜日"
                }
            }
        }
    }
}
