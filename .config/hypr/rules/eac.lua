-- Exact Audio Copy (Wine) asks to be activated as a rip moves between tracks
-- (it calls SetForegroundWindow), and misc.focus_on_activate honors that by
-- focusing EAC and warping the cursor into it, out from under whatever you
-- were doing. Ignore its activation requests; clicking it still focuses it.
hl.window_rule({
    name           = "eac",
    match          = { class = "eac.exe" },
    suppress_event = "activate activatefocus",
})
