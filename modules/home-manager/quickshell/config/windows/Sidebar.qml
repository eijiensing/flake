/*
 * Sidebar — slide-out overlay panel
 *
 * Layout overview (all values named in `dim`):
 *
 *   Screen edge ───────────────────────────────────────
 *   │←   40  →│←  8  →│←───────── 400 ──────────→│
 *   │         │        │┌──────────────────────────┐│
 *   │  bar    │  gap   ││  sidebarContent          ││
 *   │         │        ││  ┌────────────────────┐  ││
 *   │         │        ││  │  TabBar            │  ││
 *   │         │        ││  ├────────────────────┤  ││
 *   │         │        ││  │  Tab Content       │  ││
 *   │         │        ││  │  (sliding pages)   │  ││
 *   │         │        ││  └────────────────────┘  ││
 *   │         │        │└──────────────────────────┘│
 *   │         │<- anim →│  slides in/out
 */

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Hyprland
import Quickshell.Bluetooth
import qs.components

Scope {
    id: root

    // ── Public state ────────────────────────────────────────────────────
    property bool isOpen: false
    property var manager: null

    function toggle() {
        isOpen = !isOpen;
    }

    // ── Layout constants ────────────────────────────────────────────────
    readonly property QtObject dim: QtObject {
        // Sidebar shell
        readonly property int verticalBarWidth: 40
        readonly property int panelWidth: 400
        readonly property int slidePadding: 8
        readonly property int topMargin: 6
        readonly property int bottomMargin: 12
        readonly property int cornerRadius: 20
        readonly property int borderWidth: 2
        readonly property int contentPadding: 16
        readonly property int contentSpacing: 12

        // Tab height allocations
        readonly property int headerAreaHeight: 40
        readonly property int chromeOverhead: 52

        // Tab content max heights (content shrinks to fit)
        readonly property int notifTabHeight: 300
        readonly property int notifEmptyMinHeight: 64
        readonly property int trayTabHeight: 150
        readonly property int bluetoothTabHeight: 400

        // Animation durations
        readonly property int animSlow: 350
    }

    // ── Tab definitions ─────────────────────────────────────────────────
    property var tabLabels: ["Notifications", "Tray", "Bluetooth"]
    readonly property int tabCount: tabLabels.length

    // ── Active screen tracking ──────────────────────────────────────────
    property var activeScreen: {
        if (Quickshell.screens.length === 0)
            return null;
        if (!Hyprland.focusedMonitor)
            return Quickshell.screens[0];
        for (var i = 0; i < Quickshell.screens.length; i++) {
            if (Quickshell.screens[i].name === Hyprland.focusedMonitor.name) {
                return Quickshell.screens[i];
            }
        }
        return Quickshell.screens[0];
    }

    onActiveScreenChanged: isOpen = false

    // ── Per-screen instance ─────────────────────────────────────────────
    Variants {
        model: root.activeScreen ? [root.activeScreen] : []

        Item {
            property var modelData

            PanelWindow {
                id: window
                screen: modelData

                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }
                exclusionMode: ExclusionMode.Ignore
                color: "transparent"
                visible: root.isOpen
                    || sidebarContent.x > -dim.panelWidth

                // ── Backdrop click-to-dismiss ───────────────────────────
                MouseArea {
                    anchors.fill: parent
                    anchors.leftMargin: dim.verticalBarWidth
                    visible: root.isOpen
                    onClicked: root.isOpen = false
                }

                // ── Sidebar container (clips the sliding panel) ─────────
                Item {
                    id: sidebarContainer
                    width: dim.panelWidth + dim.slidePadding + 40
                    anchors {
                        top: parent.top
                        left: parent.left
                        leftMargin: dim.verticalBarWidth
                        topMargin: dim.topMargin
                    }
                    height: Math.min(
                        dim.headerAreaHeight + sidebarContent.tabContentHeight + dim.chromeOverhead,
                        parent.height - dim.bottomMargin
                    )
                    clip: true

                    Behavior on height {
                        NumberAnimation {
                            duration: dim.animSlow
                            easing.type: Easing.OutExpo
                        }
                    }

                    // ── Sidebar panel ───────────────────────────────────
                    Rectangle {
                        id: sidebarContent
                        width: dim.panelWidth
                        height: sidebarContainer.height
                        x: root.isOpen
                            ? dim.slidePadding
                            : -dim.panelWidth
                        color: ThemeManager.background
                        border.color: ThemeManager.secondary
                        border.width: dim.borderWidth
                        radius: dim.cornerRadius

                        property int currentTab: 0

                        // Per-tab content height (content-driven, capped at max)
                        readonly property real tabContentHeight: {
                            switch (currentTab) {
                            case 0: return Math.min(dim.notifTabHeight,
                                Math.max(notifScroll.contentHeight, dim.notifEmptyMinHeight));
                            case 1: {
                                // cellHeight includes the inter-row gap, so the last row
                                // has unwanted empty space. Subtract one gap from the bottom.
                                const iconSize = 64;
                                const bottomGap = trayGrid.cellHeight - iconSize;
                                const h = trayGrid.contentHeight;
                                return Math.min(dim.trayTabHeight,
                                    h > 0 ? h - bottomGap : 0);
                            }
                            case 2: return Math.min(dim.bluetoothTabHeight,
                                btManager.contentHeight);
                            }
                            return dim.notifTabHeight;
                        }

                        Behavior on x {
                            NumberAnimation {
                                duration: dim.animSlow
                                easing.type: Easing.OutExpo
                            }
                        }

                        // Consume clicks inside the panel
                        MouseArea {
                            anchors.fill: parent
                        }

                        // ── Content layout ──────────────────────────────
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: dim.contentPadding
                            spacing: dim.contentSpacing

                            // Tab header
                            TabBar {
                                Layout.fillWidth: true
                                tabs: root.tabLabels
                                currentIndex: sidebarContent.currentTab
                                onTabClicked: index =>
                                    sidebarContent.currentTab = index
                            }

                            // ── Sliding tab content ─────────────────────
                            Item {
                                id: tabContent
                                Layout.fillWidth: true
                                Layout.preferredHeight: sidebarContent.tabContentHeight
                                clip: true

                                Behavior on Layout.preferredHeight {
                                    NumberAnimation {
                                        duration: dim.animSlow
                                        easing.type: Easing.OutExpo
                                    }
                                }

                                Row {
                                    width: tabContent.width * root.tabCount
                                    height: parent.height
                                    x: -tabContent.width * sidebarContent.currentTab

                                    Behavior on x {
                                        NumberAnimation {
                                            duration: dim.animSlow
                                            easing.type: Easing.OutExpo
                                        }
                                    }

                                    // ── Tab 0: Notifications ────────────
                                    Item {
                                        width: tabContent.width
                                        height: parent.height

                                        // Placeholder shown when no notifications
                                        Text {
                                            anchors.centerIn: parent
                                            visible: root.manager && !root.manager.hasNotifications
                                            text: "No notifications"
                                            color: ThemeManager.secondary
                                            font.pixelSize: 13
                                            opacity: 0.5
                                        }

                                        Flickable {
                                                id: notifScroll
                                            visible: root.manager && root.manager.hasNotifications
                                            anchors.fill: parent
                                            clip: true
                                            contentWidth: width
                                            contentHeight: notificationColumn.height
                                            boundsBehavior: Flickable.StopAtBounds
                                            flickableDirection: Flickable.VerticalFlick

                                            Column {
                                                id: notificationColumn
                                                width: parent.width
                                                spacing: dim.contentSpacing

                                                Repeater {
                                                    model: root.manager ? root.manager.cache : []

																										delegate: NotificationCard {
																												readonly property var cachedEntry: modelData
																												notificationData: cachedEntry

																												onDismissed: {
																														if (root.manager) {
																																// Read the string ID we generated in the manager directly from the model
																																root.manager.dismissById(cachedEntry.localId);
																														}
																												}
																										}
                                                }
                                            }
                                        }
                                    }

                                    // ── Tab 1: System Tray ──────────────
                                    Item {
                                        width: tabContent.width
                                        height: parent.height

                                        GridView {
                                            id: trayGrid
                                            anchors.fill: parent
                                            clip: true
                                            cellWidth: 72
                                            cellHeight: 72

                                            model: SystemTray.items.values

                                            delegate: TrayIcon {
                                                trayItem: modelData
                                                panelWindow: window
                                            }
                                        }
                                    }

                                    // ── Tab 2: Bluetooth ────────────────
                                    Item {
                                        width: tabContent.width
                                        height: parent.height

                                        BluetoothManager {
                                            id: btManager
                                            anchors.fill: parent
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
