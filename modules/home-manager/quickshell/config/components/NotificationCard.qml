import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root

    // ── Public API ──────────────────────────────────────────────────────
    property var notificationData: null
    signal dismissed()

    // ── Styling constants ───────────────────────────────────────────────
    readonly property int cardRadius: 12
    readonly property real cardOpacity: 0.9
    readonly property int textSpacing: 4
    readonly property int summaryFontSize: 10
    readonly property int bodyFontSize: 12
    readonly property int hoverAnimDuration: 150
    readonly property real hoverLighten: 1.1

    // ── Data accessors ──────────────────────────────────────────────────
    property var cached: typeof notificationData !== "undefined"
        ? notificationData : null

    // ── Layout ──────────────────────────────────────────────────────────
    width: parent ? parent.width : 0
    // Fixed 64px base height, grows only when content requires more space.
    // 24 accounts for 12px top + 12px bottom padding.
    implicitHeight: Math.max(64, contentLayout.implicitHeight + 24)
    radius: cardRadius
    color: mouseArea.containsMouse
        ? Qt.lighter(ThemeManager.secondary, hoverLighten)
        : ThemeManager.secondary
    opacity: cardOpacity

    Behavior on color {
        ColorAnimation { duration: hoverAnimDuration }
    }

    RowLayout {
        id: contentLayout
        y: 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 10

        // App icon
        Image {
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignTop
            source: cached ? (cached.icon || cached.appIcon || "") : ""
            fillMode: Image.PreserveAspectFit
            visible: source != ""
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: textSpacing

            // Summary
            Text {
                text: cached ? cached.summary || "" : ""
                font.bold: true
                color: ThemeManager.background
                font.pixelSize: summaryFontSize
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Body (wraps up to 2 lines)
            Text {
                text: cached ? cached.body || "" : ""
                color: ThemeManager.background
                font.pixelSize: bodyFontSize
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
    }

    // ── Interaction ─────────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.dismissed()
    }
}
