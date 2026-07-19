import QtQuick
import Quickshell

Rectangle {
    id: root

    // ── Public API ──────────────────────────────────────────────────────
    // Named `trayItem` (not `modelData`) to avoid shadowing GridView's
    // implicit `modelData` in the delegate scope.
    property var trayItem: null
    property var panelWindow: null

    // ── Styling constants ───────────────────────────────────────────────
    readonly property int itemSize: 64
    readonly property int itemRadius: 12
    readonly property real itemOpacity: 0.9
    readonly property int iconSize: 32
    readonly property int hoverAnimDuration: 150
    readonly property real hoverLighten: 1.1

    // ── Layout ──────────────────────────────────────────────────────────
    width: itemSize
    height: itemSize
    radius: itemRadius
    color: mouseArea.containsMouse
        ? Qt.lighter(ThemeManager.secondary, hoverLighten)
        : ThemeManager.secondary
    opacity: itemOpacity

    Behavior on color {
        ColorAnimation { duration: hoverAnimDuration }
    }

    Image {
        anchors.centerIn: parent
        width: iconSize
        height: iconSize
        source: root.trayItem ? root.trayItem.icon || "" : ""
        fillMode: Image.PreserveAspectFit
    }

    // ── Interaction ─────────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked: mouse => {
            var item = root.trayItem;
            if (!item) return;

            if (mouse.button === Qt.RightButton) {
                var pt = mapToItem(root.panelWindow.contentItem, mouse.x, mouse.y);
                item.display(root.panelWindow, pt.x, pt.y);
            } else if (mouse.button === Qt.MiddleButton) {
                if (typeof item.secondaryActivate === "function") {
                    item.secondaryActivate();
                }
            } else {
                if (typeof item.activate === "function") {
                    item.activate();
                }
            }
        }
    }
}
