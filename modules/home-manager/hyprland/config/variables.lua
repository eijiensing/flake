local home = os.getenv("HOME")
local scheme = {
	primary = "81A8DE",
	background = "FCF6EA",
	secondary = "978D74",
	onSurface = "000000",
	onSurfaceVariant = "978D74",
}

local f = io.open(home .. "/.config/hypr/scheme/current.lua", "r")
if f then
	f:close()
	local ok, loaded = pcall(dofile, home .. "/.config/hypr/scheme/current.lua")
	if ok and type(loaded) == "table" then
		scheme = loaded
	end
end

local vars = {
	commands = {
		terminal = "alacritty",
		file_browser = "thunar",
		browser = "firefox"
	},
	colors = {
		background = "#" .. scheme.background,
		primary = "#" .. scheme.primary,
		secondary = "#" .. scheme.secondary
	}
}

return vars
