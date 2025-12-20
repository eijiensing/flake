import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root

		property var bgColor: "#fcf6ea"

    Variants {
        model: Quickshell.screens

        Item {
            property var modelData

            PanelWindow {
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
                    color: bgColor
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
                        color: bgColor
                        corner: RoundCorner.CornerEnum.TopLeft
                    }

                    RoundCorner {
                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                        }
                        implicitSize: parent.width
                        color: bgColor
                        corner: RoundCorner.CornerEnum.BottomLeft
                    }
                }
            }
        }
    }
}
