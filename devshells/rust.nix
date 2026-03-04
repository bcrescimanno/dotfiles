{ pkgs }:
let common = import ./common.nix { inherit pkgs; }; in
pkgs.mkShell {
  name = "rust";
  packages = common.packages ++ (with pkgs; [
    rustup
    cargo
    rustc
    rust-analyzer
    clippy
    rustfmt
    pkg-config
    openssl
  ]);
  shellHook = ''
    export NIX_DEVSHELL_NAME="rust"
    echo "Rust $(rustc --version) shell activated"
  '' + common.shellHook;
}
