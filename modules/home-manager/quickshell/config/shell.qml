//@ pragma UseQApplication

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Services.Notifications
import "windows"
import "components"

ShellRoot {
    id: root

    NotificationServer {
        id: notifServer
    }

    NotificationManager {
        id: notifManager
        server: notifServer
    }

    Sidebar {
        id: sidebar
        manager: notifManager
    }

    VerticalBar {
        sidebar: sidebar
        manager: notifManager
    }
}
