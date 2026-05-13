hl.window_rule({
    name  = "one-password",
    match = { class = "^(1password)$" },
    float = true,
})

hl.window_rule({
    name   = "one-password-main",
    match  = { class = "^(1password)$", title = "— 1Password$" },
    center = true,
    size   = "1000 800",
})
