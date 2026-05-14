import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    width: 28
    height: 28
    radius: 14
    color: ThemeManager.secondary
    Layout.alignment: Qt.AlignHCenter
    Layout.topMargin: 4

    Text {
        anchors.horizontalCenterOffset: 0.6
        anchors.verticalCenterOffset: 1.2
        anchors.centerIn: parent
        text: ""
        color: ThemeManager.background
        font.pixelSize: 16
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: ThemeManager.next()
    }
}
