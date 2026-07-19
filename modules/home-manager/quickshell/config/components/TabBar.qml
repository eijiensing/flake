import QtQuick
import Quickshell

Column {
    id: root

    // ── Public API ──────────────────────────────────────────────────────
    property var tabs: []
    property int currentIndex: 0
    signal tabClicked(int index)

    // ── Styling constants ───────────────────────────────────────────────
    readonly property int tabHeight: 24
    readonly property int tabSpacing: 16
    readonly property int fontSize: 12
    readonly property int indicatorHeight: 3
    readonly property int indicatorRadius: 2
    readonly property int dividerHeight: 1
    readonly property real dividerOpacity: 0.15
    readonly property int animNormal: 200
    readonly property int animSlow: 350

    readonly property int tabCount: tabs.length

    // ── Tab labels ──────────────────────────────────────────────────────
    Row {
        id: tabRow
        width: parent.width
        height: root.tabHeight
        spacing: root.tabSpacing

        readonly property real tabWidth:
            (width - spacing * (root.tabCount - 1)) / root.tabCount

        Repeater {
            model: root.tabs

            delegate: Item {
                width: tabRow.tabWidth
                height: tabRow.height

                Text {
                    anchors.centerIn: parent
                    text: modelData
                    color: root.currentIndex === index
                        ? ThemeManager.primary
                        : ThemeManager.secondary
                    font.pixelSize: root.fontSize
                    font.bold: true

                    Behavior on color {
                        ColorAnimation { duration: root.animNormal }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.tabClicked(index)
                }
            }
        }
    }

    // ── Sliding underline indicator ─────────────────────────────────────
    Rectangle {
        width: tabRow.tabWidth
        height: root.indicatorHeight
        radius: root.indicatorRadius
        color: ThemeManager.primary

        x: root.currentIndex * (tabRow.tabWidth + tabRow.spacing)

        Behavior on x {
            NumberAnimation {
                duration: root.animSlow
                easing.type: Easing.OutExpo
            }
        }
    }

    // ── Divider line ────────────────────────────────────────────────────
    Rectangle {
        width: parent.width
        height: root.dividerHeight
        color: ThemeManager.secondary
        opacity: root.dividerOpacity
    }
}
