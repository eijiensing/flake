import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.components

Scope {
    id: root

		property var sidebar
    property var notifications

    Variants {
        model: Quickshell.screens

        Item {

            property var modelData

            PanelWindow {
								id: rootPanelWindow
                screen: modelData

                anchors {
                    top: true
                    left: true
                    bottom: true
                }

                implicitWidth: 40
                exclusiveZone: 40

                Rectangle {
                    anchors.fill: parent
                    color: ThemeManager.background

										VerticalBarContent {
												sidebar: root.sidebar
												notifications: notifServer
										}
                }

            }
            PanelWindow {
                screen: modelData
								color: "transparent"

                implicitWidth: 20
                exclusionMode: ExclusionMode.Ignore

                margins {
                    left: 40
                }

                anchors {
                    top: true
                    left: true
                    bottom: true
                }

                Item {
                    anchors.fill: parent

                    RoundCorner {
                        anchors {
                            top: parent.top
                            left: parent.left
                        }
                        implicitSize: parent.width
                        color: ThemeManager.background
                        corner: RoundCorner.CornerEnum.TopLeft
                    }

                    RoundCorner {
                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                        }
                        implicitSize: parent.width
                        color: ThemeManager.background
                        corner: RoundCorner.CornerEnum.BottomLeft
                    }
                }
            }
        }
    }
}
