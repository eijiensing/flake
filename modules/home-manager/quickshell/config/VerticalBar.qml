import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Widgets
import Quickshell.Services.Notifications

Scope {
    id: root

		property color backgroundColor: "#000000"
		property color primaryColor: "#000000"
		property color secondaryColor: "#000000"

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
                    color: backgroundColor 

										VerticalBarContent {
												backgroundColor: root.backgroundColor
												primaryColor: root.primaryColor
												secondaryColor: root.secondaryColor
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
                        color: backgroundColor  
                        corner: RoundCorner.CornerEnum.TopLeft
                    }

                    RoundCorner {
                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                        }
                        implicitSize: parent.width
                        color: backgroundColor  
                        corner: RoundCorner.CornerEnum.BottomLeft
                    }
                }
            }
        }
    }
}
