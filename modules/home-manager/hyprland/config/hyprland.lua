require("binds")
require("config")
require("animations")

hl.on("hyprland.start", function()
	hl.exec_cmd("quickshell")
	hl.exec_cmd("systemctl --user start hyprpaper.service")
	hl.exec_cmd("hyprctl dispatch workspace 1")
end)
