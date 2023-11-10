{
  description = "std && flake-parts' template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };
    inputs = {
    std = {
      url = "github:divnix/std";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.devshell.follows = "devshell";
      inputs.nixago.follows = "nixago";
    };

    nixago = {
      url = "github:nix-community/nixago";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixago-exts.follows = "";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  in
    flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      inherit systems;
      # Raw flake outputs (generally not system-dependent)
      flake = {
        # packages = inputs.std.harvest inputs.self [["automation" "packages"]];
      };
      std.grow.cellsFrom = ./cells;
      std.grow.cellBlocks = with inputs.std.blockTypes; [
        # data
        (data "configs")
        #: lib
        (functions "lib")
        (installables "packages")

        #: presets
        (nixago "nixago")

        (devshells "shells")
        (functions "shellsProfiles")
      ];
      imports = [
        inputs.std.flakeModule
        # __inputs__.process-compose-flake.flakeModule
      ];
      # Flake outputs that will be split by system
      perSystem = {
        config,
        pkgs,
        inputs',
        self',
        ...
      }: {
        devShells.default = self.${pkgs.system}.automation.shells.default;
      };
    };
}
