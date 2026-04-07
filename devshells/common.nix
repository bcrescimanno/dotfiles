{ pkgs }:
{
  packages = with pkgs; [
    git
    curl
    wget
    jq
    ripgrep
    fd
    tree
    nixpkgs-fmt
    claude-code
    cloudflared
  ];

  # Appended by each devshell after its own setup. Execs zsh so the user
  # gets their full zsh config (oh-my-posh, aliases, etc.) inside the shell.
  # Env vars exported before this line are inherited by the zsh process.
  shellHook = ''
    exec ${pkgs.zsh}/bin/zsh
  '';
}
