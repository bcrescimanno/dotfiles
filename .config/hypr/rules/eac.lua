-- Exact Audio Copy (Wine) asks to be activated as a rip moves between tracks
-- (it calls SetForegroundWindow), and misc.focus_on_activate honors that by
-- focusing EAC and warping the cursor into it, out from under whatever you
-- were doing. Ignore its activation requests; clicking it still focuses it.
--
-- Float it too. Tiled by the scrolling layout, Wine loses track of the main
-- window's vertical position, so its menus open ~200px below the menu bar; and
-- the layout slides the tiled window out from under its floating dialogs.
-- Floating, both behave. Its dialogs and menus already float, so match the
-- whole class.
hl.window_rule({
    name           = "eac",
    match          = { class = "eac.exe" },
    float          = true,
    suppress_event = "activate activatefocus",
})

-- The main window's title changes to name the disc, but static rules are
-- evaluated only at map time, when it is still just "Exact Audio Copy".
hl.window_rule({
    name   = "eac-main",
    match  = { class = "eac.exe", initial_title = "^(Exact Audio Copy)$" },
    center = true,
    size   = "1600 1400",
})
