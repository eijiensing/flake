// VerticalBarContent.qml
import QtQuick
import QtQuick.Layouts

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ─────────────────────────────
        // Top section
        // ─────────────────────────────
        ColumnLayout {
            Layout.fillWidth: true
        }

        // ─────────────────────────────
        // Middle section (fills space)
        // ─────────────────────────────
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // ─────────────────────────────
        // Bottom section
        // ─────────────────────────────
        ColumnLayout {
            Layout.fillWidth: true

            Text {
                text: Qt.formatTime(new Date(), "HH:mm")
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }
        }
    }
}
