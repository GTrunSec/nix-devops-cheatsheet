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
    nix-init.url = "github:nix-community/nix-init";
    nix-init.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    flake-utils,
    ...
  }:
    (
      flake-utils.lib.eachSystem [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ]
      (
        system: let
          pkgs =
            inputs.nixpkgs.legacyPackages.${system}.appendOverlays
            (__attrValues self.overlays);
        in rec {
          devShells.default = with pkgs;
            mkShell {
              LD_LIBRARY_PATH = lib.makeLibraryPath [
                pkgs.stdenv.cc.cc
              ];
              buildInputs = [
                poetry
                nodePackages.pyright
                nodePackages.node2nix
                my-poetry-packages
              ];
            };

          devShells.init = with pkgs;
            mkShell {
              buildInputs = [
                (inputs.nix-init.packages.${system}.default)
              ];
            };

          packages = {
            inherit
              (pkgs.nodePackages)
              pyright
              node2nix
              ;
            inherit
              (pkgs.python3.pkgs)
              py7zr
              flake8-isort
              ;
          };
          hydraJobs = {
            inherit packages;
          };
        }
      )
    )
    // {
      overlays.poetry2nix = inputs.poetry2nix.overlays.default;
      overlays.default = final: prev: {
        my-poetry-packages = prev.callPackage ./poetry {};
        nvfetcher-sources = import ./nixpkgs/_sources/generated.nix {
          inherit
            (prev)
            fetchgit
            fetchurl
            fetchFromGitHub
            dockerTools
            ;
        };
        python3 =
          prev.python3.override
          (
            old: {
              packageOverrides = prev.lib.composeManyExtensions [
                (old.packageOverrides or (_: _: {}))
                (import ./nixpkgs/overlays.nix)
                (selfPythonPackages: pythonPackages: {
                  py7zr = selfPythonPackages.callPackage ./nixpkgs/py7zr.nix {};
                })
              ];
            }
          );
      };
    };
}
