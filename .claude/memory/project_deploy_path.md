---
name: deploy PATH convention
description: How the deploy command is made available in the shell
type: project
---

The `deploy` command is provided by adding `~/code/homelab-nix/scripts` to PATH conditionally in `home/common.nix`:

```zsh
[[ -d ~/code/homelab-nix/scripts ]] && path=("$HOME/code/homelab-nix/scripts" $path)
```

**Why:** The old deploy() zsh function hardcoded `nix run github:serokell/deploy-rs` which became redundant when homelab-nix got a proper scripts/deploy wrapper. The conditional PATH approach works from any directory, makes no assumptions on machines without the repo (mac, Pis), and lets the script evolve independently.
**How to apply:** If the deploy command stops working on liquidark/terra, check that ~/code/homelab-nix/scripts/deploy exists and is executable.
