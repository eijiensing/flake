hl.monitor({
  output = "DP-3",
  mode = "highrr",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "highrr",
  position = "1920x0",
  scale = 1,
})

hl.workspace_rule({ workspace = "1", monitor = "DP-3" })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })

hl.device({
	name = "ugtablet-deco-01-stylus",
	output = "DP-3"
})
