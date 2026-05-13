local variables = require("variables")

hl.bind("SUPER + Q", hl.dsp.exec_cmd(variables.commands.terminal))
hl.bind("SUPER + G", hl.dsp.exec_cmd(variables.commands.file_browser))
hl.bind("SUPER + B", hl.dsp.exec_cmd(variables.commands.browser))
hl.bind("SUPER + R", hl.dsp.exec_cmd(variables.commands.app_runner))

hl.bind("SUPER + C", hl.dsp.window.close("activewindow"))
hl.bind("SUPER + V", hl.dsp.window.float("toggle", "activewindow"))
hl.bind("SUPER + F", hl.dsp.window.fullscreen("fullscreen", "toggle", "activewindow"))

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))

-- hl.bind("SUPER + M", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind("SUPER + M", hl.dsp.exit())

hl.bind("SUPER + P", hl.dsp.workspace.move({ workspace = nil, monitor = "+1" }))

for i = 1, 9 do
	local code = 9 + i
	local ws = tostring(i)
	hl.bind(
		("SUPER + code:%d"):format(code),
		hl.dsp.focus({ workspace = ws })
	)
	hl.bind(
		("SUPER + SHIFT + code:%d"):format(code),
		hl.dsp.window.move({ workspace = ws })
	)
end

hl.bind(
	"SUPER + mouse:272",
	hl.dsp.window.drag()
)

hl.bind(
	"SUPER + mouse:273",
	hl.dsp.window.resize()
)

hl.bind(
	"Print",
	hl.dsp.exec_cmd(
		'grim -g "$(slurp)" - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png'
	)
)

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
)

hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl set +5%")
)

hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl set 5%-")
)

hl.bind(
	"XF86AudioPlay",
	hl.dsp.exec_cmd("playerctl play-pause")
)

hl.bind(
	"XF86AudioNext",
	hl.dsp.exec_cmd("playerctl next")
)

hl.bind(
	"XF86AudioPrev",
	hl.dsp.exec_cmd("playerctl previous")
)
