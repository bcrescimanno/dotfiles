-- Keep XWayland's _NET_WORKAREA in step with the monitor's reserved area.
--
-- X11 clients learn which part of the screen is free of panels from the root
-- window's _NET_WORKAREA. Hyprland (0.56) only writes it when the monitor
-- layout is arranged, never when a layer's exclusive zone changes, so it can
-- go stale: liquidark was left advertising the top 257px as reserved when the
-- bar reserves 50. Wine clamps popup menus to the work area, so every menu in
-- Exact Audio Copy opened at y=257 instead of under its menu bar.
--
-- So recompute it the way Hyprland does (MonitorLayoutController.cpp,
-- calculateUnifiedX11WorkArea) whenever the reserved area can have changed,
-- and write it with xprop. Like Hyprland, only for a single monitor; with more
-- Hyprland deletes the property and this leaves it alone.
--
-- Wine reads the work area when its wineserver starts, so a Wine prefix that
-- was already running keeps the old value until it is restarted.

local XPROP = "@xprop@"

local sync

local function workarea()
    local monitors = hl.get_monitors()
    if #monitors ~= 1 then
        return nil
    end
    local m = monitors[1]
    local r = m.reserved
    -- reserved is in logical pixels, width/height in physical ones
    local x, y = r.left, r.top
    local w = m.width / m.scale - r.left - r.right
    local h = m.height / m.scale - r.top - r.bottom
    local zero = hl.get_config("xwayland:force_zero_scaling")
    if zero == true or zero == 1 then
        x, y, w, h = x * m.scale, y * m.scale, w * m.scale, h * m.scale
    end
    if w <= 0 or h <= 0 then
        return nil
    end
    return string.format("%d, %d, %d, %d", math.floor(x), math.floor(y), math.floor(w), math.floor(h))
end

-- Runs once, a moment after the last event, so the layer's exclusive zone has
-- been applied to the monitor's reserved area by then.
sync = hl.timer(function()
    sync:set_enabled(false)
    local value = workarea()
    if value then
        hl.exec_cmd(XPROP .. " -root -f _NET_WORKAREA 32c -set _NET_WORKAREA '" .. value .. "'")
    end
end, { timeout = 250, type = "repeat" })
sync:set_enabled(false)

local function schedule()
    sync:set_enabled(true)
end

for _, event in ipairs({
    "hyprland.start",
    "config.reloaded",
    "layer.opened",
    "layer.closed",
    "monitor.added",
    "monitor.removed",
    "monitor.layout_changed",
}) do
    hl.on(event, schedule)
end

-- XWayland starts lazily, possibly after all of the above.
hl.on("window.open", function(w)
    if w.xwayland then
        schedule()
    end
end)

schedule()
