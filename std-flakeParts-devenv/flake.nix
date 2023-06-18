{
  description = "std && flake-parts && devenv template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    mission-control.url = "github:Platonic-Systems/mission-control";
    flake-root.url = "github:srid/flake-root";
  };
  inputs = {
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
    std-ext.url = "github:gtrunsec/std-ext";
    std-ext.inputs.std.follows = "std";
    std-ext.inputs.nixpkgs.follows = "nixpkgs";
    std-ext.inputs.org-roam-book-template.follows = "std/blank";
    flops.follows = "std-ext/flops";
  };
  outputs = inputs @ {
    self,
      flake-parts,
      devenv,
      nixpkgs,
      ...
  }: let
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    __inputs__ = (inputs.std-ext.inputs.flops.inputs.call-flake ./lock).inputs;
  in
    flake-parts.lib.mkFlake {
      inputs = inputs // __inputs__;
    } {
      inherit systems;
      # Raw flake outputs (generally not system-dependent)
      flake = {
        inherit __inputs__;
        devenvModules = (inputs.flops.lib.configs.haumea.setInit { src = ./devenvModules;
                                                                   loader = inputs.flops.inputs.haumea.lib.loaders.path;
                                                                 }
        ).outputsForTarget "default";
      };
      std.grow.cellsFrom = ./cells;
      std.grow.cellBlocks = with inputs.std.blockTypes; [
        #: lib
        (functions "lib")
        (nixago "nixago")
        (installables "packages")

        #: presets
        (nixago "nixago")

        (devshells "devshells")
        (data "devshellsProfiles")
        (nixago "nixago")
      ];
      imports = [
        inputs.std.flakeModule
        inputs.devenv.flakeModule
        inputs.mission-control.flakeModule
        inputs.flake-root.flakeModule
      ];
      # Flake outputs that will be split by system
      perSystem = {
        config,
          pkgs,
          inputs',
          self',
          ...
      }: {
        mission-control.scripts = {
          hello = {
            description = "Say Hello";
            exec = "echo Hello";
          };
          cliche = {
            description = "Run cliche example";
            exec = inputs.std-ext.${pkgs.system}.cliche.entrypoints.example;
          };
          ponysay = {
            exec = pkgs.ponysay;
          };
        };
        packages = import ./packages {inherit pkgs inputs';};
        devenv.shells = {
          default = {
            name = "default";
            enterShell = config.mission-control.banner;
            packages = [
              config.mission-control.wrapper
              inputs.std-ext.${pkgs.system}.cliche.entrypoints.example
            ];
            imports = [
              self.devenvModules.default
              self.devenvModules.lint
              self.devenvModules.rust
            ];
          };
        };
      };
    };
}
