hl.window_rule({
	match = { class = "steam", title = "Friends List" },
	no_initial_focus = true,
	float = true,
})

hl.window_rule({
    match = {
        float = true,
    },
    persistent_size = true,
})
