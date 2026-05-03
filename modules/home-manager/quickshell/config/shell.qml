//@ pragma UseQApplication

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Services.Notifications
import "windows"

ShellRoot {
    id: root
		property color backgroundColor: "#FCF6EA"
		property color primaryColor: "#81A8DE"
		property color secondaryColor: "#978D74"

		NotificationServer {
			id: notifServer
			onNotification: n => n.tracked = true
		}

		Sidebar {
			id: sidebar
			backgroundColor: root.backgroundColor
			primaryColor: root.primaryColor
			secondaryColor: root.secondaryColor
			notifications: notifServer
		}

		VerticalBar {
			backgroundColor: root.backgroundColor
			primaryColor: root.primaryColor
			secondaryColor: root.secondaryColor
			sidebar: sidebar
		}
}
