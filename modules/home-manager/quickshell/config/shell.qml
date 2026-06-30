//@ pragma UseQApplication

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Services.Notifications
import "windows"

ShellRoot {
    id: root

		NotificationServer {
			id: notifServer
			onNotification: n => {
					n.tracked = true
					var cached = {
						appName: n.appName || "",
						summary: n.summary || "",
						body: n.body || "",
						notif: n
					}
					var copy = sidebar.notificationCache.slice()
					copy.push(cached)
					sidebar.notificationCache = copy
				}
		}

    Sidebar {
        id: sidebar
        notifications: notifServer
    }

    VerticalBar {
        sidebar: sidebar
        notifications: notifServer
    }
}
