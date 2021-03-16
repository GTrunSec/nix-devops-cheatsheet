let
  nixpkgs = (import (builtins.fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/7c06b2145ddc21a20c7f178c3391bdaf8497fae2.tar.gz)) { };
  easy-hls-src = (import (builtins.fetchTarball "https://github.com/jkachmar/easy-hls-nix/archive/main.tar.gz"));
  nix-script-src = (builtins.fetchTarball "https://github.com/BrianHicks/nix-script/archive/main.tar.gz");
  easy-hls = nixpkgs.callPackage easy-hls-src {
    ghcVersions = [ "8.8.4" ];
  };
  nix-script-bin = nixpkgs.callPackage "${nix-script-src}/nix-script" { };
  nix-script-haskell = nixpkgs.callPackage "${nix-script-src}/nix-script-haskell" { };
  nix-script-bash = nixpkgs.callPackage "${nix-script-src}/nix-script-bash" { };
  haskellPackages = nixpkgs.haskell.packages.ghc884;
in
with nixpkgs;
mkShell {
  name = "nix-scrpt-env";
  buildInputs = [
    easy-hls
    nix-script-bin
    nix-script-haskell
    nix-script-bash
    (haskellPackages.ghcWithPackages (p: with p;[
      relude
      ghc
    ]))
  ];
  shellHook = "

    ";
}
