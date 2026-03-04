{ pkgs }:
let common = import ./common.nix { inherit pkgs; }; in
pkgs.mkShell {
  name = "cpp";
  packages = common.packages ++ (with pkgs; [
    gcc
    clang
    cmake
    ninja
    pkg-config
    gdb
    valgrind
    ccache
  ]);
  shellHook = ''
    export NIX_DEVSHELL_NAME="cpp"
    echo "C++ shell activated (gcc $(gcc --version | head -1))"
  '' + common.shellHook;
}
