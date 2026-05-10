hl.window_rule({
  match = { class = "steam", title = "Friends List" },
  float = true,
})

hl.window_rule({
  match = { class = "steam_app_.*" },
  fullscreen = true,
})
