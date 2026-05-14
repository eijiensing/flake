hl.window_rule({
	match = { class = "steam", title = "Friends List" },
	no_initial_focus = true,
	float = true,
})

-- Main game window - fullscreen
hl.window_rule({
	match = { class = "steam_app_.*", title = "^$" },
	fullscreen = true,
})

-- Popups/launchers from games - float them
hl.window_rule({
	match = { class = "steam_app_.*", title = ".+" },
	float = true,
})

hl.window_rule({
	match = {
		class = "steam"
	},

	suppress_event = "activatefocus"
})
