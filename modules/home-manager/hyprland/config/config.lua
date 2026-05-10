local variables = require("variables")

hl.config({
	general = {
		border_size = 2,
		col = {
			active_border = { colors = { variables.colors.primary, angle = 45 } },
			inactive_border = "0x00000000",
		},
		gaps_in = 4,
		gaps_out = 8,
		layout = "dwindle",
	},
	input = {
		touchpad = {
			natural_scroll = true
		},
		accel_profile = "flat",
		kb_options = "caps:escape",
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true
	},

	decoration = {
		blur = {
			brightness = 1,
			contrast = 1.400000,
			enabled = true,
			ignore_opacity = true,
			new_optimizations = true,
			noise = 0,
			passes = 2,
			size = 3,
			xray = true,
		},

		shadow = {
			color = "rgba(00000055)",
			enabled = true,
			offset = { 0, 2 },
			range = 20,
			render_power = 3,
		},
		rounding = 16,
	},
	animations = {
		enabled = true,
	},
})
