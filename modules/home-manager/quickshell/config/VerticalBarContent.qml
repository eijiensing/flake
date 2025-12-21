// VerticalBarContent.qml
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ─────────────────────────────
        // Top section
        // ─────────────────────────────
        Item {
            id: topSection
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight

            // Example content (replace later)
            Rectangle {
                width: parent.width
                height: 40
                color: "transparent"
            }
        }

        // ─────────────────────────────
        // Middle section (fills space)
        // ─────────────────────────────
        Item {
            id: middleSection
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Example content
            Rectangle {
                anchors.centerIn: parent
                width: 10
                height: 10
                radius: 5
                color: "#000000"
            }
        }

        // ─────────────────────────────
        // Bottom section
        // ─────────────────────────────
        Item {
            id: bottomSection
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight

            // Example content
            Rectangle {
                width: parent.width
                height: 40
                color: "transparent"
            }
        }
    }

    // Public slots for future use
    default property alias topContent: topSection.children
    property alias middleContent: middleSection.children
    property alias bottomContent: bottomSection.children
}
