-- Exact Audio Copy (Wine) asks to be activated as a rip moves between tracks
-- (it calls SetForegroundWindow), and misc.focus_on_activate honors that by
-- focusing EAC and warping the cursor into it, out from under whatever you
-- were doing. Ignore its activation requests; clicking it still focuses it.
hl.window_rule({
    name           = "eac",
    match          = { class = "eac.exe" },
    suppress_event = "activate activatefocus",
})

-- EAC's dialogs (the "Extracting Audio Data" progress window above all) float,
-- and floating windows stay put on screen while the scrolling layout slides
-- the tiled main window around, so the dialog ends up stranded over some other
-- window. No event fires when the layout moves a window, so poll instead: a
-- timer, running only while EAC has a floating window, re-centers each one
-- over the main window whenever that window moves or resizes. Between moves a
-- dialog stays wherever you drag it.
--
-- Wine's popup menus (and combo-box drop-downs, tooltips) are override-redirect
-- X windows, which Hyprland also reports as floating eac.exe windows. Moving
-- one away from where it opened leaves it unusable, so leave them alone. Hyprland
-- exposes no override-redirect flag, but those windows are untitled while every
-- EAC dialog has a caption, so the title tells them apart.
local CLASS = "eac.exe"

local last = {} -- dialog address -> parent geometry it was last centered on
local follow

local function tick()
    local parent, dialogs = nil, {}
    for _, w in ipairs(hl.get_windows({ class = CLASS })) do
        if w.mapped and not w.floating then
            parent = w
        elseif w.mapped and w.title ~= "" then
            dialogs[#dialogs + 1] = w
        end
    end
    if #dialogs == 0 then
        last = {}
        follow:set_enabled(false)
        return
    end
    if not parent then
        return
    end

    local seen = {}
    for _, d in ipairs(dialogs) do
        seen[d.address] = true
        local key = table.concat({ parent.at.x, parent.at.y, parent.size.x, parent.size.y, d.size.x, d.size.y }, " ")
        if last[d.address] ~= key and d.workspace and parent.workspace and d.workspace.id == parent.workspace.id then
            last[d.address] = key
            hl.dispatch(hl.dsp.window.move({
                x      = math.floor(parent.at.x + (parent.size.x - d.size.x) / 2),
                y      = math.floor(parent.at.y + (parent.size.y - d.size.y) / 2),
                window = "address:" .. d.address,
            }))
        end
    end
    for addr in pairs(last) do
        if not seen[addr] then
            last[addr] = nil
        end
    end
end

follow = hl.timer(tick, { timeout = 50, type = "repeat" })

hl.on("window.open", function(w)
    if w.class == CLASS then
        follow:set_enabled(true)
    end
end)
