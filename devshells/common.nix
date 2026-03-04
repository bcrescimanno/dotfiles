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
  ];
}
