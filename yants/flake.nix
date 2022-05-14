{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    devshell.url = "github:numtide/devshell";
    yants.url = "github:divnix/yants";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    devshell,
    yants,
    ...
  }:
    (
      flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"]
      (system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system}.appendOverlays [devshell.overlay];
      in rec {
        inherit yants;
        someType = with inputs.yants "std"; enum "red" ["red"];
      })
    )
    // {
      overlays.default = final: prev: {};
    };
}
