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
        onNotification: n => n.tracked = true
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
