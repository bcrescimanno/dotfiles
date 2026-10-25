-- Exact Audio Copy (Wine) asks to be activated as a rip moves between tracks
-- (it calls SetForegroundWindow), and misc.focus_on_activate honors that by
-- focusing EAC and warping the cursor into it, out from under whatever you
-- were doing. Ignore its activation requests; clicking it still focuses it.
hl.window_rule({
    name           = "eac",
    match          = { class = "eac.exe" },
    suppress_event = "activate activatefocus",
})

-- EAC's rip progress dialog ("Extracting Audio Data") floats, and floating
-- windows stay put on screen while the scrolling layout slides the tiled main
-- window around, so the dialog ends up stranded over some other window for the
-- whole rip. No event fires when the layout moves a window, so poll instead: a
-- timer, running only while EAC has a window open besides the main one,
-- re-centers the progress dialog over the main window whenever that window
-- moves or resizes. Between moves it stays wherever you drag it.
--
-- Only that dialog. Every other EAC dialog floats and behaves normally, and
-- Wine's popup menus are floating eac.exe windows too (untitled
-- override-redirect ones), which a move leaves misplaced or unusable.
local CLASS = "eac.exe"
local PROGRESS = "Extracting Audio Data"

local last = {} -- dialog address -> parent geometry it was last centered on
local follow

local function tick()
    local parent, dialogs, floating = nil, {}, false
    for _, w in ipairs(hl.get_windows({ class = CLASS })) do
        if w.mapped and not w.floating then
            parent = w
        elseif w.mapped then
            floating = true
            -- the title can arrive after the window maps, so match it here
            -- rather than in window.open
            if w.title == PROGRESS then
                dialogs[#dialogs + 1] = w
            end
        end
    end
    if not floating then
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
