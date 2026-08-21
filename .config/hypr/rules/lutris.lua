-- Lutris wants an explicit size, and the right one is machine-specific: the
-- default suits liquidark's 5120x2160 ultrawide, while a laptop panel needs a
-- size that fits inside its (scaled) logical resolution. Machines that aren't
-- the ultrawide pass their own.
---@param opts? { size?: string }
return function(opts)
    opts = opts or {}

    hl.window_rule({
        name    = "lutris",
        match   = { class = "net.lutris.Lutris" },
        no_blur = true,
        float   = true,
        center  = true,
        size    = opts.size or "2000 1400",
    })
end
