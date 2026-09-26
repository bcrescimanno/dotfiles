-- Bitwarden browser-extension pop-out (passkey confirmation, "pop out" vault).
--
-- This CANNOT be a plain hl.window_rule. Firefox maps the pop-out with the
-- generic title "Mozilla Firefox" — identical to a normal browser window — and
-- only retitles it to "Extension: (Bitwarden Password Manager) - Bitwarden —
-- Mozilla Firefox" a moment later. `float`, `size` and `center` are STATIC rule
-- effects (WindowRuleEffectContainer.hpp): evaluated once, at map time, and
-- never again on a title change. So a title-matching rule would never fire.
--
-- Instead, react to the title change itself and float that one window by
-- address. The `floating` guard makes it a one-shot: once floated, later title
-- changes are ignored, and a pop-out you deliberately tile stays tiled.

local POPOUT_PREFIX = "Extension: (Bitwarden Password Manager)"

hl.on("window.title", function(w)
    if w.class ~= "firefox" or w.floating then
        return
    end
    if w.title:find(POPOUT_PREFIX, 1, true) ~= 1 then
        return
    end

    -- Float ONLY. Hyprland already places a newly floated window centered at
    -- the size the client asks for, so an explicit resize + center just added
    -- two more visible jumps. The remaining jump — the window mapping tiled,
    -- the layout reflowing, then snapping back — is unavoidable: at map time
    -- the pop-out is indistinguishable from a normal Firefox window.
    local sel = "address:" .. w.address
    hl.dispatch(hl.dsp.window.set_prop({ prop = "no_anim", value = "1", window = sel }))
    hl.dispatch(hl.dsp.window.float({ action = "enable", window = sel }))
end)

-- The Bitwarden desktop app. It comes to the front for every vault unlock and
-- SSH-agent authorization prompt, and tiled it reflowed the whole workspace
-- each time. Float it like 1Password (rules/1password.lua): the class is known
-- at map time, so a plain static rule works here, unlike the pop-out above.
-- The class depends on how it was launched: "bitwarden" as a native Wayland
-- client (the XDG autostart entry runs bitwarden-app directly), "Bitwarden"
-- under XWayland (upstream's /opt/Bitwarden/bitwarden launcher forces X11
-- whenever DISPLAY is set). Match both.
hl.window_rule({
    name   = "bitwarden-desktop",
    match  = { class = "^([Bb]itwarden)$" },
    float  = true,
    center = true,
    size   = "1000 800",
})
