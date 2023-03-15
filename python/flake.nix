{
  description = "Python development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    poetry2nix.url = "github:nix-community/poetry2nix";
    poetry2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    flake-utils,
    ...
  }:
    {}
    // (
      flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"]
      (
        system: let
          pkgs =
            inputs.nixpkgs.legacyPackages.${system}.appendOverlays
            [
              inputs.poetry2nix.overlay
              self.overlays.default
            ];
        in rec {
          devShell = with pkgs;
            mkShell {
              buildInputs = [
                poetry
                nodePackages.pyright
                nodePackages.node2nix
                my-python-packages
              ];
            };

          packages = {
            inherit
              (pkgs.nodePackages)
              pyright
              node2nix
              ;
          };
          hydraJobs = {
            inherit packages;
          };
        }
      )
    )
    // {
      overlays.default = final: prev: {
        my-python-packages = prev.callPackage ./poetry {};
      };
    };
}
