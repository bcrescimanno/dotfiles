---
name: nvidia_webkit_dmabuf
description: WebKitGTK/Tauri apps crash on liquidark's NVIDIA GPU until WEBKIT_DISABLE_DMABUF_RENDERER=1; session env lives in .config/uwsm/env
type: project
---

On liquidark (RTX 5090, proprietary driver, Hyprland/Wayland), any **WebKitGTK**
app — and therefore any **Tauri** app — dies at startup with:

```
Gdk-Message: Error 71 (Protocol error) dispatching to Wayland display.
```

WebKit's DMA-BUF renderer exports buffers the NVIDIA driver describes with
modifiers Hyprland won't accept, so the compositor terminates the connection.
Fix is `WEBKIT_DISABLE_DMABUF_RENDERER=1`, set session-wide in
`.config/uwsm/env` (2026-08-02, found via the Music Assistant Companion app).

`WEBKIT_DISABLE_COMPOSITING_MODE=1` and `GDK_BACKEND=x11` are the next rungs if
the first isn't enough, but the dmabuf variable alone has been sufficient.

**Where session env vars belong**: `.config/uwsm/env`, sourced by uwsm for
everything the compositor launches. It is wired up in `machines/liquidark.nix`
via `home.file.".config/uwsm/env"`, so it is liquidark-only — celes and terra do
not get it. Prefer this over per-app `xdg.desktopEntries` overrides, which only
cover launcher launches and only the one app.

Same family as the RTX 5090's Firefox VA-API stall recorded in the homelab-nix
memory: on this machine, GPU **buffer-sharing / hardware-video paths** are the
thing that breaks, not the applications.
