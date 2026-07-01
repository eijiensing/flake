import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Hyprland
import Quickshell.Bluetooth
import qs.components

Scope {
    id: root

    // State to toggle the sidebar open and closed
    property bool isOpen: false
    property var notifications
    property var notificationCache: []

    function toggle() {
        isOpen = !isOpen;
    }

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
                visible: root.isOpen || sidebarContent.x > -400

                MouseArea {
                    anchors.fill: parent
                    anchors.leftMargin: 40
                    visible: root.isOpen
                    onClicked: root.isOpen = false
                }

                Item {
                    id: sidebarContainer
                    width: 408
                    anchors {
                        top: parent.top
                        left: parent.left
                        leftMargin: 40
                        topMargin: 6
                    }
                    height: Math.min(headerHeight + tabContentHeight + 52, parent.height - 12)
                    clip: true

                    Behavior on height {
                        NumberAnimation {
                            duration: 350
                            easing.type: Easing.OutExpo
                        }
                    }

                    property real headerHeight: 40
                    property real tabContentHeight: {
                        switch (sidebarContent.currentTab) {
                            case 0: return 300;
                            case 1: return 150;
                            case 2: return 400;
                        }
                        return 300;
                    }

                    Rectangle {
                        id: sidebarContent
                        width: 400
                        height: sidebarContainer.height
                        x: root.isOpen ? 8 : -400
                        color: ThemeManager.background
                        border.color: ThemeManager.secondary
                        border.width: 2
                        radius: 20
                        property int currentTab: 0

                        Behavior on x {
                            NumberAnimation {
                                duration: 350
                                easing.type: Easing.OutExpo
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            // Consume clicks to prevent them from falling through to the background
                        }

                        ColumnLayout {
                            id: contentLayout
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12

                            // Tabs header
                            Column {
                                Layout.fillWidth: true
                                    width: parent.width

                                    Row {
                                        id: tabBar
                                        width: parent.width

                                        height: 24
                                        spacing: 16

                                        property int tabCount: 3
                                        property real tabWidth: (width - spacing * (tabCount - 1)) / tabCount

                                        Repeater {
                                            model: ["Notifications", "Tray", "Bluetooth"]

                                            delegate: Item {
                                                width: tabBar.tabWidth
                                                height: tabBar.height

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: modelData
                                                    color: sidebarContent.currentTab === index ? ThemeManager.primary : ThemeManager.secondary
                                                    font.pixelSize: 12
                                                    font.bold: true

                                                    Behavior on color {
                                                        ColorAnimation {
                                                            duration: 200
                                                        }
                                                    }
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: sidebarContent.currentTab = index
                                                }
                                            }
                                        }
                                    }

                                    // Sliding underline
                                    Rectangle {
                                        id: tabIndicator
                                        width: tabBar.tabWidth
                                        height: 3
                                        radius: 2
                                        color: ThemeManager.primary

                                        x: sidebarContent.currentTab * (tabBar.tabWidth + tabBar.spacing)

                                        Behavior on x {
                                            NumberAnimation {
                                                duration: 350
                                                easing.type: Easing.OutExpo
                                            }
                                        }
                                    }

                                    // Divider
                                    Rectangle {
                                        width: parent.width
                                        height: 1
                                        color: ThemeManager.secondary
                                        opacity: 0.15
                                    }
                                }

                                // Tab Content Area
                            Item {
                                id: tabContent
                                Layout.fillWidth: true
                                Layout.preferredHeight: sidebarContainer.tabContentHeight
                                clip: true

                                Behavior on Layout.preferredHeight {
                                    NumberAnimation {
                                        duration: 350
                                        easing.type: Easing.OutExpo
                                    }
                                }

                                Row {
                                    width: parent.width * 3
                                    height: parent.height
                                    x: -parent.width * sidebarContent.currentTab
                                    Behavior on x {
                                        NumberAnimation {
                                            duration: 350
                                            easing.type: Easing.OutExpo
                                        }
                                    }

                                    // Tab 0: Notifications
                                    Item {
                                        width: parent.width / 3
                                        height: parent.height

                                        Flickable {
                                            id: notificationScroll
                                            anchors.fill: parent
                                            clip: true
                                            contentWidth: width
                                            contentHeight: notificationColumn.height
                                            boundsBehavior: Flickable.StopAtBounds
                                            flickableDirection: Flickable.VerticalFlick
                                            // model: root.notifications.trackedNotifications

                                            Column {
                                                id: notificationColumn
                                                width: parent.width
                                                spacing: 12

                                                Repeater {
                                                    model: root.notificationCache

                                                    delegate: Rectangle {
                                                        property var cached: typeof modelData !== "undefined" ? modelData : null
                                                        property var notif: cached ? cached.notif : null

                                                        width: notificationColumn.width
                                                        height: 100
                                                        radius: 12
                                                        color: delegateMouseArea.containsMouse ? Qt.lighter(ThemeManager.primary, 1.1) : ThemeManager.primary
                                                        opacity: 0.9
                                                        Behavior on color {
                                                            ColorAnimation {
                                                                duration: 150
                                                            }
                                                        }

                                                        ColumnLayout {
                                                            anchors.fill: parent
                                                            anchors.margins: 16
                                                            spacing: 4

                                                            RowLayout {
                                                                Layout.fillWidth: true
                                                                Text {
                                                                    text: cached ? cached.appName || "" : ""
                                                                    font.bold: true
                                                                    color: ThemeManager.background
                                                                    font.pixelSize: 12
                                                                    Layout.fillWidth: true
                                                                    elide: Text.ElideRight
                                                                }
                                                            }

                                                            Text {
                                                                text: cached ? cached.summary || "" : ""
                                                                font.bold: true
                                                                color: ThemeManager.background
                                                                font.pixelSize: 14
                                                                elide: Text.ElideRight
                                                                Layout.fillWidth: true
                                                            }
                                                            Text {
                                                                text: cached ? cached.body || "" : ""
                                                                color: ThemeManager.background
                                                                font.pixelSize: 12
                                                                elide: Text.ElideRight
                                                                maximumLineCount: 2
                                                                wrapMode: Text.Wrap
                                                                Layout.fillWidth: true
                                                                Layout.fillHeight: true
                                                            }
                                                        }

                                                        MouseArea {
                                                            id: delegateMouseArea
                                                            anchors.fill: parent
                                                            hoverEnabled: true
                                                            cursorShape: Qt.PointingHandCursor
                                                            onClicked: {
                                                                        var item = cached
                                                                        if (notif && typeof notif.dismiss === "function") {
                                                                            notif.dismiss()
                                                                        }
                                                                        root.notificationCache = root.notificationCache.filter(function(i) {
                                                                            return i.notif !== item.notif
                                                                        })
                                                                        console.log("after filter, cache len:", root.notificationCache.length)
                                                                    }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    // Tab 1: System Tray
                                    Item {
                                        width: parent.width / 3
                                        height: parent.height

                                        GridView {
                                            id: trayList
                                            anchors.fill: parent
                                            clip: true
                                            cellWidth: 72
                                            cellHeight: 72
                                            anchors.margins: 8

                                            model: SystemTray.items.values

                                            delegate: Rectangle {
                                                required property var modelData

                                                width: 56
                                                height: 56
                                                radius: 12
                                                color: trayMouseArea.containsMouse ? Qt.lighter(ThemeManager.primary, 1.1) : ThemeManager.primary
                                                opacity: 0.9
                                                Behavior on color {
                                                    ColorAnimation {
                                                        duration: 150
                                                    }
                                                }

                                                Image {
                                                    anchors.centerIn: parent
                                                    width: 32
                                                    height: 32
                                                    source: modelData.icon || ""
                                                    fillMode: Image.PreserveAspectFit
                                                }

                                                MouseArea {
                                                    id: trayMouseArea
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                                    onClicked: mouse => {
                                                        if (mouse.button === Qt.RightButton) {
                                                            var pt = mapToItem(window.contentItem, mouse.x, mouse.y);
                                                            modelData.display(window, pt.x, pt.y);
                                                        } else if (mouse.button === Qt.MiddleButton) {
                                                            if (typeof modelData.secondaryActivate === "function") {
                                                                modelData.secondaryActivate();
                                                            }
                                                        } else {
                                                            if (typeof modelData.activate === "function") {
                                                                modelData.activate();
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    // Tab 2: Bluetooth
                                    Item {
                                        width: parent.width / 3
                                        height: parent.height

                                        BluetoothManager {
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
