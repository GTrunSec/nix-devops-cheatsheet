{
  description = "haskell-develop";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/3a7674c896847d18e598fa5da23d7426cb9be3d2";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    easy-hls-nix = { url = "github:jkachmar/easy-hls-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-script = { url = "github:BrianHicks/nix-script"; inputs.nixpkgs.follows = "nixpkgs"; flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, flake-compat, easy-hls-nix, nix-script }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
            ];
            config = { };
          };
        in
        rec {
          #haskellPackages = pkgs.haskell.packages.ghc884;
          devShell = with pkgs; mkShell {
            buildInputs = [
              easy-hls
              nix-script-bin
              nix-script-haskell
              nix-script-bash
              (haskellPackages.ghcWithPackages
                (p: with p;  [
                  relude
                ]))
            ];
          };
        }
      )
    ) //
    {
      overlay = final: prev: {
        nix-script-bin = prev.callPackage "${nix-script}/nix-script" { };
        nix-script-haskell = prev.callPackage "${nix-script}/nix-script-haskell" { };
        nix-script-bash = prev.callPackage "${nix-script}/nix-script-bash" { };
        easy-hls = prev.callPackage easy-hls-nix {
          ghcVersions = [ "8.10.4" ];
        };
      };
    };
}
