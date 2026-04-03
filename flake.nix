{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "claude-code"
        ];
      };

      # A helper that builds a home-manager configuration for a given
      # system architecture and list of modules. This avoids repeating
      # the same boilerplate for each machine.
      mkHome = system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          modules = modules;
        };


    in
    {
      homeConfigurations = {
        "brian@liquidark" = mkHome "x86_64-linux" [
          ./machines/liquidark.nix
        ];

        "brian@mac" = mkHome "aarch64-darwin" [
          ./machines/mac.nix
        ];

        "brian@pirateship" = mkHome "aarch64-linux" [
          ./machines/pirateship.nix
        ];

        "brian@rivendell" = mkHome "aarch64-linux" [
          ./machines/rivendell.nix
        ];

        "brian@mirkwood" = mkHome "aarch64-linux" [
          ./machines/mirkwood.nix
        ];

        "brian@terra" = mkHome "x86_64-linux" [
          ./machines/terra.nix
        ];

        "brian@orthanc" = mkHome "x86_64-linux" [
          ./machines/orthanc.nix
        ];
      };

      # Expose home configurations as checks so `nix flake check` evaluates
      # them and catches Nix errors (undefined variables, type errors, etc.)
      # even with --no-build.
      checks = {
        x86_64-linux."brian@liquidark" =
          self.homeConfigurations."brian@liquidark".activationPackage;
        aarch64-darwin."brian@mac" =
          self.homeConfigurations."brian@mac".activationPackage;
        aarch64-linux."brian@pirateship" =
          self.homeConfigurations."brian@pirateship".activationPackage;
        aarch64-linux."brian@rivendell" =
          self.homeConfigurations."brian@rivendell".activationPackage;
        aarch64-linux."brian@mirkwood" =
          self.homeConfigurations."brian@mirkwood".activationPackage;
        x86_64-linux."brian@terra" =
          self.homeConfigurations."brian@terra".activationPackage;
        x86_64-linux."brian@orthanc" =
          self.homeConfigurations."brian@orthanc".activationPackage;
      };

      devShells = forAllSystems (system:
          let pkgs = pkgsFor system;
          in {
            ruby = import ./devshells/ruby.nix { inherit pkgs; };
            cpp = import ./devshells/cpp.nix { inherit pkgs; };
            rust = import ./devshells/rust.nix { inherit pkgs; };
            default = import ./devshells/default.nix { inherit pkgs; };
          }
        );
    };
}
