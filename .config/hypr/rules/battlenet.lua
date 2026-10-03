hl.window_rule({
    name  = "battlenet",
    match = { class = "battle.net.exe" },
    float = true,
})

-- Under Wine the main window maps at nearly the full monitor size (it never
-- asks to be fullscreen; it's just that big). The login window that precedes it
-- has a sensible size of its own, so only the main window gets one.
hl.window_rule({
    name   = "battlenet-main",
    match  = { class = "battle.net.exe", title = "Battle.net" },
    center = true,
    size   = "2000 1400",
})
