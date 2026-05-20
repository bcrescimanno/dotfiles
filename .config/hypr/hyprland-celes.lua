-- Hyprland configuration for celes (laptop)
-- https://wiki.hypr.land/0.55.0/

-- Window rules — one file per application
require("rules.1password")
require("rules.lutris")
require("rules.rpi-imager")
require("rules.steam")
require("rules.rmpc")

--------------------
---- MONITORS ----
--------------------

-- Built-in laptop display. eDP-1 is the standard DRM name; adjust if yours differs.
-- Use `hyprctl monitors` to confirm the output name after first boot.
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "0x0",
	scale = 1,
})

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -- mako")
	hl.exec_cmd("uwsm app -- swayosd-server")
	hl.exec_cmd("uwsm app -- quickshell -p /home/brian/code/liquidark-shell")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		layout = "scrolling",

		gaps_in = { top = 0, right = 5, bottom = 10, left = 5 },
		gaps_out = { top = 10, right = 20, bottom = 20, left = 20 },

		border_size = 4,
		col = {
			active_border = { colors = { "rgba(d6acffee)", "rgba(69ff94ee)" }, angle = 45 },
			inactive_border = "rgba(59595966)",
		},
		resize_on_border = true,
		hover_icon_on_border = true,
		allow_tearing = false,
	},

	decoration = {
		rounding = 10,
		rounding_power = 4,

		dim_modal = true,
		dim_strength = 0.2,

		blur = {
			enabled = true,
			size = 4,
			passes = 2,
			vibrancy = 0.1696,
		},

		shadow = {
			enabled = true,
			range = 4,
		},
	},

	animations = {
		enabled = true,
	},

	input = {
		follow_mouse = 1,
		sensitivity = -0.2,

		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
		},
	},

	cursor = {
		sync_gsettings_theme = true,
	},

	dwindle = {
		preserve_split = true,
	},

	-- column_width at 0.45 works better on laptop-sized displays than the
	-- 0.32 used on the ultrawide liquidark setup.
	scrolling = {
		column_width = 0.45,
		fullscreen_on_one_column = false,
		focus_fit_method = 0,
		follow_focus = true,
		follow_min_visible = 0.6,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		focus_on_activate = true,
	},

	layout = {
		single_window_aspect_ratio = "10 11",
	},
})

-----------------------
---- WORKSPACE RULES ----
-----------------------

hl.workspace_rule({ workspace = "1", layout = "scrolling", persistent = true })
hl.workspace_rule({ workspace = "2", layout = "monocle", persistent = true })

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.5, bezier = "default", style = "slidevert" })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local terminal = "uwsm app -- ghostty -e tmux"
local menu = "uwsm app -- walker"
local browser = "uwsm app -- firefox"
local exit = "uwsm app -- wleave"
local rmpc = "uwsm app -- ghostty --title=rmpc -e rmpc"
local nvim = "uwsm app -- ghostty --title=nvim -e nvim"
local fileManager = "uwsm app -- ghostty -e yazi"

-- Launch
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal), { description = "Terminal" })
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(rmpc), { description = "Music Player" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser), { description = "Firefox" })
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(nvim), { description = "Neovim" })
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager), { description = "File Manager" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu), { description = "Walker Launcher" })
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close window" })

-- Windows and workspaces
hl.bind(mainMod .. " + TAB", hl.dsp.window.cycle_next(), { description = "Cycle Windows" })
hl.bind(mainMod .. " + ALT + end", hl.dsp.exec_cmd("systemctl suspend"), { description = "Suspend" })
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd(exit), { description = "Exit Menu" })

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Move focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + l", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.layout("swapcol r"))

-- Switch workspaces
hl.bind(mainMod .. " + j", hl.dsp.focus({ workspace = "+1" }), { description = "Next workspace" })
hl.bind(mainMod .. " + k", hl.dsp.focus({ workspace = "-1" }), { description = "Previous workspace" })

-- Switch workspaces / move windows to workspaces
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshot
hl.bind("ALT + SHIFT + 4", hl.dsp.exec_cmd("hyprshot -m region"), { description = "Screenshot" })

-- Media keys
local osdclient = "swayosd-client"

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(osdclient .. " --output-volume raise"),
	{ locked = true, repeating = true, description = "Volume up" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(osdclient .. " --output-volume lower"),
	{ locked = true, repeating = true, description = "Volume down" }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd(osdclient .. " --output-volume mute-toggle"),
	{ locked = true, repeating = true, description = "Mute" }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd(osdclient .. " --input-volume mute-toggle"),
	{ locked = true, repeating = true, description = "Mute microphone" }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(osdclient .. " --brightness raise"),
	{ locked = true, repeating = true, description = "Brightness up" }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(osdclient .. " --brightness lower"),
	{ locked = true, repeating = true, description = "Brightness down" }
)

-- Precise 1% adjustments with Alt modifier
hl.bind(
	"ALT + XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(osdclient .. " --output-volume +1"),
	{ locked = true, repeating = true, description = "Volume up precise" }
)
hl.bind(
	"ALT + XF86AudioLowerVolume",
	hl.dsp.exec_cmd(osdclient .. " --output-volume -1"),
	{ locked = true, repeating = true, description = "Volume down precise" }
)
hl.bind(
	"ALT + XF86MonBrightnessUp",
	hl.dsp.exec_cmd(osdclient .. " --brightness +1"),
	{ locked = true, repeating = true, description = "Brightness up precise" }
)
hl.bind(
	"ALT + XF86MonBrightnessDown",
	hl.dsp.exec_cmd(osdclient .. " --brightness -1"),
	{ locked = true, repeating = true, description = "Brightness down precise" }
)

-- Playerctl
hl.bind(
	"XF86AudioNext",
	hl.dsp.exec_cmd(osdclient .. " --playerctl next"),
	{ locked = true, description = "Next track" }
)
hl.bind(
	"XF86AudioPause",
	hl.dsp.exec_cmd(osdclient .. " --playerctl play-pause"),
	{ locked = true, description = "Pause" }
)
hl.bind(
	"XF86AudioPlay",
	hl.dsp.exec_cmd(osdclient .. " --playerctl play-pause"),
	{ locked = true, description = "Play" }
)
hl.bind(
	"XF86AudioPrev",
	hl.dsp.exec_cmd(osdclient .. " --playerctl previous"),
	{ locked = true, description = "Previous track" }
)
