{ pkgs }:
let common = import ./common.nix { inherit pkgs; }; in
pkgs.mkShell {
  name = "ruby";
  packages = common.packages ++ (with pkgs; [
    ruby_3_3
    bundler
    libyaml
    libffi
    zlib
    openssl
    postgresql
    redis
    nodejs
  ]);
  shellHook = ''
    echo "Ruby $(ruby --version) shell activated"
    export GEM_HOME=$HOME/.gems
    export PATH=$GEM_HOME/bin:$PATH
  '';
}
