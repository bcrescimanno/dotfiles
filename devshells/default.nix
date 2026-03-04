{ pkgs }:
let common = import ./common.nix { inherit pkgs; }; in
pkgs.mkShell {
  name = "default";
  packages = common.packages ++ (with pkgs; [
  ]);
  shellHook = ''
    echo "Default shell activated"
  '';
}
