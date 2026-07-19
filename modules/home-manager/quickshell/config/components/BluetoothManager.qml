import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

Item {
    id: root

    property var adapter: Bluetooth.defaultAdapter

    // ── Device model filters ────────────────────────────────────────────
    readonly property var knownDevices:
        adapter ? adapter.devices.values.filter(d => d.connected || d.bonded || d.paired) : []

    readonly property var unknownDevices:
        adapter ? adapter.devices.values.filter(d => !d.connected && !d.bonded && !d.paired) : []

    readonly property bool discovering: adapter && adapter.discovering

    // Expose the total content height so the sidebar can size dynamically
    readonly property real contentHeight:
        64 + (adapter && adapter.enabled ? 8 + scrollArea.contentHeight : 0)

    onAdapterChanged: {
        stopDiscovery()
    }

    function startDiscovery() {
        if (adapter && adapter.enabled && !adapter.discovering)
            adapter.discovering = true
    }

    function stopDiscovery() {
        if (adapter && adapter.discovering)
            adapter.discovering = false
    }

    Connections {
        target: adapter
        function onEnabledChanged() {
            if (adapter && !adapter.enabled)
                stopDiscovery()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        // ── Adapter header ───────────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            Layout.alignment: Qt.AlignTop
            radius: 12
            color: ThemeManager.secondary

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2

                    Text {
                        text: adapter ? adapter.name : "No adapter"
                        color: ThemeManager.background
                        font.bold: true
                        font.pixelSize: 12
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: {
                            if (!adapter) return "Unavailable"
                            switch (adapter.state) {
                                case BluetoothAdapterState.Disabled: return "Disabled"
                                case BluetoothAdapterState.Enabled: return "Enabled"
                                case BluetoothAdapterState.Enabling: return "Enabling..."
                                case BluetoothAdapterState.Disabling: return "Disabling..."
                                case BluetoothAdapterState.Blocked: return "Blocked by rfkill"
                                default: return "Unknown"
                            }
                        }
                        color: ThemeManager.background
                        font.pixelSize: 10
                        opacity: 0.7
                    }
                }

                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: Qt.rgba(0, 0, 0, adapter && adapter.enabled ? 0.25 : 0.0)
                    border.width: 2
                    border.color: {
                        var c = ThemeManager.background
                        return Qt.rgba(c.r, c.g, c.b, adapter && adapter.enabled ? 1.0 : 0.5)
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "\u23FB"
                        color: {
                            var c = ThemeManager.background
                            return Qt.rgba(c.r, c.g, c.b, adapter && adapter.enabled ? 1.0 : 0.5)
                        }
                        font.pixelSize: 16
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { if (adapter) adapter.enabled = !adapter.enabled }
                    }
                }
            }
        }

        // ── Scrollable device lists ──────────────────────────────────────
        Flickable {
            id: scrollArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: width
            contentHeight: knownSection.height + pairButtonSection.height + unknownSection.height + 30
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            visible: adapter && adapter.enabled
            interactive: contentHeight > height

            // ── Known devices ────────────────────────────────────────────
            Column {
                id: knownSection
                width: parent.width
                spacing: 6

                Text {
                    width: parent.width
                    text: "Known Devices"
                    color: ThemeManager.secondary
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                    opacity: 0.6
                    leftPadding: 8
                    visible: knownRepeater.count > 0
                    height: visible ? 16 : 0
                }

                Repeater {
                    id: knownRepeater
                    model: knownDevices

                    delegate: Rectangle {
                        required property var modelData
                        width: knownSection.width
                        height: 56
                        radius: 10
                        color: modelData.connected ? ThemeManager.primary : ThemeManager.secondary
                        opacity: modelData.connected ? 1 : 0.7

                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 2

                                Text {
                                    text: modelData.name || modelData.deviceName || modelData.address
                                    color: ThemeManager.background
                                    font.bold: true
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Row {
                                    spacing: 8

                                    Text {
                                        text: {
                                            if (!modelData) return ""
                                            switch (modelData.state) {
                                                case BluetoothDeviceState.Connected: return "Connected"
                                                case BluetoothDeviceState.Connecting: return "Connecting..."
                                                case BluetoothDeviceState.Disconnecting: return "Disconnecting..."
                                                default: return "Disconnected"
                                            }
                                        }
                                        color: ThemeManager.background
                                        font.pixelSize: 9
                                    }

                                    Text {
                                        visible: modelData && modelData.batteryAvailable
                                        text: modelData ? Math.round(modelData.battery * 100) + "%" : ""
                                        color: ThemeManager.background
                                        font.pixelSize: 9
                                        opacity: 0.6
                                    }

                                    Text {
                                        visible: modelData && (modelData.paired || modelData.bonded) && !modelData.connected
                                        text: "Paired"
                                        color: ThemeManager.background
                                        font.pixelSize: 9
                                        opacity: 0.5
                                    }
                                }
                            }

                            Rectangle {
                                width: 32
                                height: 32
                                radius: 16
                                color: {
                                    var c = ThemeManager.background
                                    return Qt.rgba(c.r, c.g, c.b, 0.25)
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.connected ? "\u25A0" : "\u25B6"
                                    color: ThemeManager.background
                                    font.pixelSize: 14
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (!modelData) return
                                        if (modelData.connected) {
                                            modelData.trusted = false
                                            modelData.disconnect()
                                        } else {
                                            modelData.connect()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Text {
                    width: parent.width
                    visible: knownRepeater.count === 0
                    text: "No known devices"
                    color: ThemeManager.secondary
                    font.pixelSize: 11
                    opacity: 0.5
                    leftPadding: 8
                    topPadding: 4
                    height: visible ? 20 : 0
                }
            }


            // ── "Pair new device" button ─────────────────────────────────
            Item {
                id: pairButtonSection
                width: parent.width
                height: 40
                y: knownSection.height + 8

                Rectangle {
                    id: pairButton
                    width: parent.width
                    height: 36
                    radius: 8
                    color: root.discovering ? ThemeManager.primary : "transparent"
                    opacity: root.discovering ? 1 : 0.9

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: root.discovering ? "■" : "+"
                            color: root.discovering ? ThemeManager.background : ThemeManager.secondary
                            font.pixelSize: 14
                            font.weight: Font.Bold
                        }

                        Text {
                            text: root.discovering ? "Stop Scanning" : "Pair New Device"
                            color: root.discovering ? ThemeManager.background : ThemeManager.secondary
                            font.pixelSize: 11
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.discovering) {
                                stopDiscovery()
                            } else {
                                startDiscovery()
                            }
                        }
                    }
                }
            }

            // ── Nearby / unknown devices ─────────────────────────────────
            Column {
                id: unknownSection
                width: parent.width
                spacing: 6
                y: pairButtonSection.y + pairButtonSection.height + 10
                visible: root.discovering

                Text {
                    width: parent.width
                    text: root.discovering && unknownRepeater.count === 0
                          ? "Scanning for devices..."
                          : "Nearby Devices"
                    color: ThemeManager.secondary
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                    opacity: unknownRepeater.count > 0 ? 0.6 : 0.5
                    leftPadding: 8
                    height: 20
                }

                Repeater {
                    id: unknownRepeater
                    model: unknownDevices

                    delegate: Rectangle {
                        required property var modelData
                        width: unknownSection.width
                        height: 52
                        radius: 10
                        color: Qt.rgba(ThemeManager.secondary.r, ThemeManager.secondary.g, ThemeManager.secondary.b, 0.9)
                        opacity: modelData.pairing ? 1 : 0.9

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 1

                                Text {
                                    text: modelData.name || modelData.deviceName || modelData.address
                                    color: ThemeManager.background
                                    font.bold: true
                                    font.pixelSize: 11
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: modelData.pairing ? "Pairing..." : "Discovered"
                                    color: ThemeManager.background
                                    font.pixelSize: 9
                                    opacity: 0.6
                                }
                            }

                            Rectangle {
                                width: 28
                                height: 28
                                radius: 14
                                color: {
                                    var c = ThemeManager.background
                                    return Qt.rgba(c.r, c.g, c.b, 0.2)
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "\u2795"
                                    color: ThemeManager.background
                                    font.pixelSize: 12
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (!modelData) return
                                        modelData.pair()
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
