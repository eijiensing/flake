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
        _applyAlacritty();
        _applyNeovim();
    }

    function next() {
        switchTo((currentIndex + 1) % wallpapers.length);
    }

    // ── Theme config (read-only, written by Nix) ─────────────────────────
    FileView {
        id: themesFile
        path: "/home/eiji/.local/share/shell/themes.json"
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
        path: "/home/eiji/.local/share/shell/wallpaper-state.json"
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
            }
        }
    }

    Process {
        id: alacrittyProc
        running: false

        onExited: function (code) {
            if (code !== 0) {
                console.warn("alacritty command failed:", code);
            }
        }
    }

    Process {
        id: neovimProc
        running: false
        onExited: code => {
            if (code !== 0)
                console.warn("neovim theme command failed:", code);
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
        const gtkTheme = theme.dark ? "Adwaita" : "Adwaita-Light";
        const scheme = theme.dark ? "prefer-dark" : "prefer-light";

        gtkProc.running = false;
        gtkProc.command = ["bash", "-c", `
        gsettings set org.gnome.desktop.interface gtk-theme '${gtkTheme}' &&
        gsettings set org.gnome.desktop.interface color-scheme '${scheme}'
    `];
        gtkProc.running = true;
    }

    function _applyAlacritty() {
        if (!theme)
            return;
        alacrittyProc.running = false;
        alacrittyProc.command = ["bash", "-c", `
				ln -sf ~/.local/share/shell/alacritty-themes/${theme.alacritty}.toml ~/.local/share/shell/alacritty-theme.toml &&
				touch ~/.config/alacritty/theme-trigger.toml
    `];
        alacrittyProc.running = true;
    }

    function _applyNeovim() {
        if (!theme)
            return;
        neovimProc.running = false;
        neovimProc.command = ["bash", "-c", `
        echo 'vim.cmd.colorscheme("${theme.neovim}")' > ~/.local/share/shell/nvim-theme.lua &&
        for sock in /run/user/1001/nvim.*.0; do
            nvim --server "$sock" --remote-expr "execute('colorscheme ${theme.neovim}')" 2>/dev/null
        done
    `];
        neovimProc.running = true;
    }

    Component.onCompleted: themesFile.reload()
}
