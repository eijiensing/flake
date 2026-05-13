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
	center = true,
})

hl.window_rule({
	match = {
		class = "steam"
	},

	suppress_event = "activatefocus"
})

hl.on("window.open", function(w)
	local width = w.size.x
	local height = w.size.y

	-- Float windows smaller than a threshold
	if width < 900 and height < 700 then
		hl.dispatch(hl.dsp.window.float({ action = "enable", window = w }))
		hl.dispatch(hl.dsp.window.center({ window = w }))
	end
end)
