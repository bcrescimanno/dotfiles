# Dotfiles Memory

## Deploy Command
- [deploy PATH convention](project_deploy_path.md) — how `deploy` is provided in zsh (conditional PATH, not a function)

## liquidark (NVIDIA)
- [WebKitGTK dmabuf crash](nvidia_webkit_dmabuf.md) — every Tauri/WebKitGTK app needs `WEBKIT_DISABLE_DMABUF_RENDERER=1`; session env belongs in `.config/uwsm/env`, which is liquidark-only
