# Dotfiles Memory

## Deploy Command
- [deploy PATH convention](project_deploy_path.md) — how `deploy` is provided in zsh (conditional PATH, not a function)

## liquidark (NVIDIA)
- [WebKitGTK dmabuf crash](nvidia_webkit_dmabuf.md) — every Tauri/WebKitGTK app needs `WEBKIT_DISABLE_DMABUF_RENDERER=1`; session env belongs in `.config/uwsm/env`, which is liquidark-only

## Git / SSH
- [programs.git not enabled](project_programs_git_not_enabled.md) — HM renders no git config; ssh-agent.nix writes git/config raw; enabling would globalize hooksPath
