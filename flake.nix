{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      # Use the same nixpkgs as the rest of the config to avoid
      # pulling in a second copy of the package set.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # A helper that builds a home-manager configuration for a given
      # system architecture and list of modules. This avoids repeating
      # the same boilerplate for each machine.
      mkHome = system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = modules;
        };
    in
    {
      homeConfigurations = {

        # Arch Linux desktop (x86_64)
        "brian@liquidark" = mkHome "x86_64-linux" [
          ./machines/liquidark.nix
        ];

        # macOS (Apple Silicon — change to x86_64-darwin for Intel Mac)
        "brian@mac" = mkHome "aarch64-darwin" [
          ./machines/mac.nix
        ];

        # NixOS Pi — aarch64
        "brian@pirateship" = mkHome "aarch64-linux" [
          ./machines/pirateship.nix
        ];

      };
    };
}
