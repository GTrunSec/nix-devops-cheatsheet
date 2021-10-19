{
  description = "Nix Script Flake Example";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    nix_script = { url = "github:BrianHicks/nix-script"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, flake-compat, nix_script }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
              nix_script.overlay
            ];
            config = { };
          };
          nix-script-shell = with pkgs; [
            nix-script
            nix-script-haskell
            nix-script-bash
            (haskellPackages.ghcWithPackages (p: with p; [ relude ]))
          ];
        in
        {
          apps = {
            tests = flake-utils.lib.mkApp {
              drv = with import nixpkgs { inherit system; };
                pkgs.writeShellScriptBin "nix-script-checks" ''
                  export PATH=${
                     pkgs.lib.strings.makeBinPath
                       ([ findutils coreutils ] ++ nix-script-shell)
                   }
                   set -xeuo pipefail
                   (
                   scripts/exp-with-dependencies.hs
                   scripts/exp-hello.hs
                   )
                '';
            };
          };
          #haskellPackages = pkgs.haskell.packages.ghc884;
          devShell = with pkgs;
            mkShell {
              buildInputs = [
                nix-script
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
      overlay = final: prev: { };
    };
}
