hl.window_rule({
    name         = "steam",
    match        = { class = "steam" },
    no_blur      = true,
    float        = true,
    idle_inhibit = "fullscreen",
})

hl.window_rule({
    name   = "steam-main",
    match  = { class = "steam", title = "Steam" },
    center = true,
    size   = "2000 1400",
})

hl.window_rule({
    name  = "steam-friends",
    match = { class = "steam", title = "Friends List" },
    size  = "460 800",
})

hl.window_rule({
    name        = "steam-settings",
    match       = { class = "steam", initial_title = "Steam Settings" },
    decorate    = false,
    no_shadow   = true,
    border_size = 1,
})

hl.window_rule({
    name  = "steam-other",
    match = { class = "steam_app_default" },
    float = true,
})

hl.window_rule({
    name   = "steam-other-again",
    match  = { class = "steam_app_default", title = "Steam" },
    center = true,
})
