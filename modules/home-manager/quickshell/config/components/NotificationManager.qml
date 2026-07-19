// NotificationManager.qml
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: root

    property var cache: []
    property var server: null
    readonly property bool hasNotifications: cache.length > 0

    function dismissById(localId) {
        var initialLength = cache.length;

        cache = cache.filter(function (entry) {
            var keep = entry.localId !== localId;
            return keep;
        });
    }

    onServerChanged: {
        if (server) {
            server.onNotification.connect(handleNotification);
        }
    }

    function handleNotification(n) {
        var entry = {
            localId: Date.now() + Math.random(),
            appName: n.appName || "",
            appIcon: n.appIcon || "",
            icon: n.icon || "",
            summary: n.summary || "",
            body: n.body || ""
        };

        for (var key in n) {
            console.log(key + ": " + n[key]);
        }
        console.log(n.desktopEntry);

        // Instantly dismiss system notification
        n.dismiss();

        var copy = cache.slice();
        copy.push(entry);
        cache = copy; // Reassign to trigger QML property bindings
    }
}
