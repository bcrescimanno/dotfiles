{ pkgs }:
let common = import ./common.nix { inherit pkgs; }; in
pkgs.mkShell {
  name = "default";
  packages = common.packages ++ (with pkgs; [
  ]);
  shellHook = ''
    export NIX_DEVSHELL_NAME="default"
    echo "Default shell activated"
  '' + common.shellHook;
}
