import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Hyprland

Scope {
    id: root

    property color backgroundColor: "#FCF6EA"
    property color primaryColor: "#81A8DE"
    property color secondaryColor: "#978D74"

    // State to toggle the sidebar open and closed
    property bool isOpen: false
    property var notifications

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
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: 40
                        topMargin: 6
                        bottomMargin: 6
                    }
                    clip: true

                    Rectangle {
                        id: sidebarContent
                        width: 400
                        height: parent.height
                        x: root.isOpen ? 8 : -400
                        color: root.backgroundColor
                        border.color: root.secondaryColor
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
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 24

                            Column {
                                Layout.fillWidth: true
                                spacing: 4

                                // Tabs header
                                Column {
                                    width: parent.width

                                    Row {
                                        id: tabBar
                                        width: parent.width

                                        height: 24
                                        spacing: 16

                                        property int tabCount: 3
                                        property real tabWidth: (width - spacing * (tabCount - 1)) / tabCount

                                        Repeater {
                                            model: ["Notifications", "Tray", "Apps"]

                                            delegate: Item {
                                                width: tabBar.tabWidth
                                                height: tabBar.height

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: modelData
                                                    color: sidebarContent.currentTab === index ? root.primaryColor : root.secondaryColor
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
                                        color: root.primaryColor

                                        x: sidebarContent.currentTab * (tabBar.tabWidth + tabBar.spacing)

                                        Behavior on x {
                                            NumberAnimation {
                                                duration: 350
                                                easing.type: Easing.OutExpo
                                            }
                                        }
                                    }

                                    // Divider (now guaranteed visible)
                                    Rectangle {
                                        width: parent.width
                                        height: 1
                                        color: root.secondaryColor
                                        opacity: 0.15
                                    }
                                }
                            }

                            // Tab Content Area
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true

                                Row {
                                    width: parent.width * 2
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
                                        width: parent.width / 2
                                        height: parent.height

                                        ListView {
                                            id: notificationList
                                            anchors.fill: parent
                                            clip: true
                                            spacing: 12

                                            model: root.notifications.trackedNotifications.values

                                            delegate: Rectangle {
                                                required property var modelData

                                                width: notificationList.width
                                                height: 100
                                                radius: 12
                                                color: delegateMouseArea.containsMouse ? Qt.lighter(root.primaryColor, 1.1) : root.primaryColor
                                                opacity: 0.9
                                                Behavior on color {
                                                    ColorAnimation {
                                                        duration: 150
                                                    }
                                                }

                                                MouseArea {
                                                    id: delegateMouseArea
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        if (typeof modelData.invoke === "function") {
                                                            modelData.invoke("default");
                                                        } else if (typeof modelData.invokeDefaultAction === "function") {
                                                            modelData.invokeDefaultAction();
                                                        } else if (typeof modelData.dismiss === "function") {
                                                            modelData.dismiss();
                                                        }
                                                    }
                                                }

                                                ColumnLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: 16
                                                    spacing: 4

                                                    RowLayout {
                                                        Layout.fillWidth: true
                                                        Text {
                                                            text: modelData.appName
                                                            font.bold: true
                                                            color: root.backgroundColor
                                                            font.pixelSize: 12
                                                            Layout.fillWidth: true
                                                            elide: Text.ElideRight
                                                        }
                                                    }

                                                    Text {
                                                        text: modelData.summary
                                                        font.bold: true
                                                        color: root.backgroundColor
                                                        font.pixelSize: 14
                                                        elide: Text.ElideRight
                                                        Layout.fillWidth: true
                                                    }
                                                    Text {
                                                        text: modelData.body
                                                        color: root.backgroundColor
                                                        font.pixelSize: 12
                                                        elide: Text.ElideRight
                                                        maximumLineCount: 2
                                                        wrapMode: Text.Wrap
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true
                                                    }
                                                }

                                                // Dismiss button overlay (appears on hover)
                                                Rectangle {
                                                    anchors.right: parent.right
                                                    anchors.top: parent.top
                                                    anchors.margins: 8
                                                    width: 24
                                                    height: 24
                                                    radius: 12
                                                    color: root.secondaryColor
                                                    opacity: dismissArea.containsMouse ? 1.0 : 0.0
                                                    Behavior on opacity {
                                                        NumberAnimation {
                                                            duration: 150
                                                        }
                                                    }

                                                    Text {
                                                        anchors.centerIn: parent
                                                        text: "✕"
                                                        color: root.backgroundColor
                                                        font.bold: true
                                                    }

                                                    MouseArea {
                                                        id: dismissArea
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: modelData.dismiss()
                                                    }
                                                }
                                            }

                                            // Nice animations for adding/removing items
                                            add: Transition {
                                                NumberAnimation {
                                                    property: "opacity"
                                                    from: 0
                                                    to: 1
                                                    duration: 300
                                                }
                                                NumberAnimation {
                                                    property: "x"
                                                    from: 100
                                                    to: 0
                                                    duration: 300
                                                    easing.type: Easing.OutExpo
                                                }
                                            }
                                            remove: Transition {
                                                NumberAnimation {
                                                    property: "opacity"
                                                    to: 0
                                                    duration: 300
                                                }
                                            }
                                            displaced: Transition {
                                                NumberAnimation {
                                                    properties: "x,y"
                                                    duration: 300
                                                    easing.type: Easing.OutExpo
                                                }
                                            }
                                        }
                                    }

                                    // Tab 1: System Tray
                                    Item {
                                        width: parent.width / 2
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
                                                color: trayMouseArea.containsMouse ? Qt.lighter(root.primaryColor, 1.1) : root.primaryColor
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
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
