{
  description = "std && flake-parts' template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };
  inputs = {
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
    std.inputs.devshell.follows = "std-ext/devshell";
    std.inputs.nixago.follows = "std-ext/nixago";
    std-ext.url = "github:gtrunsec/std-ext";
    std-ext.inputs.std.follows = "std";
    std-ext.inputs.nixpkgs.follows = "nixpkgs";
    std-ext.inputs.org-roam-book-template.follows = "std/blank";
    flops.follows = "std-ext/flops";
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
    __inputs__ = (inputs.flops.inputs.call-flake ./lock).inputs;
  in
    flake-parts.lib.mkFlake {
      inputs = inputs // __inputs__;
    } {
      inherit systems;
      # Raw flake outputs (generally not system-dependent)
      flake = {
        inherit __inputs__;
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
