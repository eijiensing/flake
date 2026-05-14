// VerticalBarContent.qml
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    anchors.fill: parent
		property var sidebar

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

						Rectangle {
								width: 28
								height: 28
								radius: 14
								color: ThemeManager.secondary
								Layout.alignment: Qt.AlignHCenter
								Layout.bottomMargin: 4

								Text {
										anchors.horizontalCenterOffset: 0.6
										anchors.centerIn: parent
										text: ""
										color: ThemeManager.background
										font.pixelSize: 24
										font.bold: true
								}

								MouseArea {
										anchors.fill: parent
										cursorShape: Qt.PointingHandCursor
										onClicked: sidebar.toggle()
								}
						}

						RadialVolume {}
						RadialBattery {}
						ThemePicker {}
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
                color: ThemeManager.secondary
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDateTime(clock.date, "HH")
                font.pixelSize: 16
            }

            Text {
                color: ThemeManager.secondary
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDateTime(clock.date, "mm")
                font.pixelSize: 16
                Layout.bottomMargin: 6
            }

            // Date dd/MM
            Text {
                color: ThemeManager.secondary
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDateTime(clock.date, "dd/MM")
                font.pixelSize: 8
            }

            // Day of week
            Text {
                color: ThemeManager.secondary
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
