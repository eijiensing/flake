// VerticalBarContent.qml
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    anchors.fill: parent

		property var textColor: "#978d74"

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Top section
        ColumnLayout {
						Layout.topMargin: 12
            Layout.fillWidth: true
        }

        // Middle section (fills space)
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Bottom section (clock)
        ColumnLayout {
						Layout.bottomMargin: 12
            Layout.fillWidth: true
            spacing: 0

            Text {
								color: textColor 
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDateTime(clock.date, "HH")
                font.pixelSize: 16
            }

            Text {
								color: textColor 
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDateTime(clock.date, "mm")
                font.pixelSize: 16
								Layout.bottomMargin: 6
            }

            Text {
								color: textColor 
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDateTime(clock.date, "dd/MM")
                font.pixelSize: 8
            }
						Text {
								color: textColor
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
