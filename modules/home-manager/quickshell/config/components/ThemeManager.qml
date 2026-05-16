pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // ── Current state ────────────────────────────────────────────────────
    property int currentIndex: 0
    property var wallpapers: []

    // Derived — bind these in your components
    readonly property var theme: wallpapers.length > 0 ? wallpapers[currentIndex] : null
    property color primary: theme ? theme.primary : "#ffffff"
    property color secondary: theme ? theme.secondary : "#888888"
    property color background: theme ? theme.background : "#000000"
    property color text: theme ? theme.text : "#000000"
    Behavior on primary {
        ColorAnimation {
            duration: 400
            easing.type: Easing.InOutCubic
        }
    }
    Behavior on secondary {
        ColorAnimation {
            duration: 400
            easing.type: Easing.InOutCubic
        }
    }
    Behavior on background {
        ColorAnimation {
            duration: 400
            easing.type: Easing.InOutCubic
        }
    }
    Behavior on text {
        ColorAnimation {
            duration: 400
            easing.type: Easing.InOutCubic
        }
    }
    // readonly property color primary: "#876B22"
    // readonly property color secondary: "#4B3B2C"
    // readonly property color background: "#1D1916"

    readonly property string name: theme ? theme.name : ""

    // ── Public API ───────────────────────────────────────────────────────
    function switchTo(index) {
        if (index < 0 || index >= wallpapers.length)
            return;
        currentIndex = index;
        stateAdapter.currentIndex = index;
        _applyHyprpaper();
        _applyBorder();
        _applyGtk();
        _applyGhostty();
    }

    function next() {
        switchTo((currentIndex + 1) % wallpapers.length);
    }

    // ── Theme config (read-only, written by Nix) ─────────────────────────
    FileView {
        id: themesFile
        path: "/home/eiji/.local/share/themes.json"
        watchChanges: false
        onLoaded: {
            root.wallpapers = themesAdapter.wallpapers;
            // Load persisted index only after themes are available
            stateFile.reload();
        }

        JsonAdapter {
            id: themesAdapter
            property var wallpapers: []
        }
    }

    // ── Persisted state (read/write) ─────────────────────────────────────
    FileView {
        id: stateFile
        path: "/home/eiji/.local/share/wallpaper-state.json"
        watchChanges: false
        onLoaded: {
            const saved = stateAdapter.currentIndex;
            const valid = saved >= 0 && saved < root.wallpapers.length;
            root.currentIndex = valid ? saved : 0;
            root._applyHyprpaper();
            root._applyBorder();
        }
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: stateAdapter
            property int currentIndex: 0
        }
    }

    // ── Hyprpaper command ────────────────────────────────────────────────
    Process {
        id: hyprpaperProc
        running: false
        onExited: code => {
            if (code !== 0)
                console.warn("hyprpaper command failed:", code);
        }
    }

    // ── Hyprland border command ──────────────────────────────────────────
    Process {
        id: borderProc
        running: false
        onExited: code => {
            if (code !== 0)
                console.warn("hyprctl border command failed:", code);
        }
    }

    Process {
        id: gtkProc
        running: false

        onExited: function (code) {
            if (code !== 0) {
                console.warn("gtk css write failed:", code);
            } else {
                thunarQuitProc.running = true;
            }
        }
    }

    Process {
        id: thunarQuitProc
        command: ["thunar", "--quit"]
        running: false
    }

    Process {
        id: ghosttyProc
        running: false
        onExited: code => {
            if (code !== 0)
                console.warn("ghostty theme command failed:", code);
        }
    }

    // ── Private helpers ──────────────────────────────────────────────────
    function _applyHyprpaper() {
        if (!theme)
            return;
        hyprpaperProc.running = false;
        hyprpaperProc.command = ["hyprctl", "hyprpaper", "wallpaper", "," + theme.path];
        hyprpaperProc.running = true;
    }

    function _applyBorder() {
        if (!theme)
            return;
        borderProc.running = false;
        borderProc.command = ["bash", "-c", `hyprctl eval 'hl.config({ general = { col = { active_border = { colors = {"${theme.primary}"} } } } })' && ` + `hyprctl dispatch 'hl.dsp.window.set_prop({ prop = "no_anim", value = "0" })'`];
        borderProc.running = true;
    }

    function _applyGtk() {
        if (!theme)
            return;
        const p = theme.primary;
        const s = theme.secondary;
        const bg = theme.background;
        const t = theme.text;
        gtkProc.running = false;
        gtkProc.command = ["bash", "-c", `{ echo '@define-color primary    ${p};'; echo '@define-color secondary  ${s};'; echo '@define-color background ${bg};'; echo '@define-color text       ${t};'; } > /home/eiji/.config/gtk-3.0/colors.css`];
        gtkProc.running = true;
    }

    function _applyGhostty() {
        if (!theme)
            return;
        ghosttyProc.running = false;
        ghosttyProc.command = ["bash", "-c", `echo 'theme = ${theme.terminal}' > /home/eiji/.config/ghostty/theme.ghostty && ` + `systemctl reload --user app-com.mitchellh.ghostty.service`];
        ghosttyProc.running = true;
    }

    Component.onCompleted: themesFile.reload()
}
