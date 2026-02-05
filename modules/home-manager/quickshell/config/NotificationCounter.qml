import QtQuick
import QtQml.Models
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

Item {
    id: root

		property color backgroundColor: "#000000"
		property color primaryColor: "#000000"
		property color secondaryColor: "#000000"

    // Hover tracking
    property bool hoverCounter: false
    property bool hoverPane: false
    property bool paneVisible: hoverCounter || hoverPane

    NotificationServer {
        id: notifications
        onNotification: n => n.tracked = true
    }

    /* ---------------- Notification counter ---------------- */
    WrapperMouseArea {
        id: counterArea
        hoverEnabled: true
        onEntered: {
            root.hoverCounter = true
            hoverTimer.restart()
        }
        onExited: {
            root.hoverCounter = false
            hoverTimer.restart()
        }

        Item {
            implicitWidth: 36
            implicitHeight: 36 

            Text {
                anchors.centerIn: parent
                text: notifications.trackedNotifications.values.length
                font.bold: true
                color: secondaryColor
            }
        }
    }

    /* ---------------- Hover timer ---------------- */
    Timer {
        id: hoverTimer
        interval: 100 // 0.1s delay to prevent flicker
        repeat: false
				onTriggered: pane.visible = root.paneVisible && notifications.trackedNotifications.values.length > 0
    }

		property var itemHeight: 48
		property var popupMargin: 8

    /* ---------------- PopupWindow for notifications ---------------- */
    PopupWindow {
        id: pane
        visible: false
				color: "transparent"
				implicitHeight: (notifications.trackedNotifications.values.length * (itemHeight + popupMargin)) + popupMargin

				anchor.window: rootPanelWindow
				anchor.rect.x: rootPanelWindow.width
				anchor.rect.y: 90

        WrapperMouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                root.hoverPane = true
                hoverTimer.restart()
            }
            onExited: {
                root.hoverPane = false
                hoverTimer.restart()
            }

            Rectangle {
                anchors.fill: parent
								topRightRadius: 8
								bottomRightRadius: 8
                color: backgroundColor 

                Column {
                    id: list
                    anchors.fill: parent
                    anchors.margins: popupMargin
                    spacing: popupMargin

                    /* ---------------- Notifications ---------------- */
                    Instantiator {
                        model: notifications.trackedNotifications.values

                        delegate: Rectangle {
                            required property var modelData

                            width: list.width
                            height: itemHeight
                            radius: 6
                            color: secondaryColor

                            Text {
                                anchors.centerIn: parent
                                width: parent.width - 20
                                elide: Text.ElideRight
                                text: modelData.summary
                                color: "white"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: modelData.dismiss()
                            }
                        }

                        onObjectAdded: (index, object) => object.parent = list
                        onObjectRemoved: (index, object) => {}
                    }
                }
            }
        }
    }
}
