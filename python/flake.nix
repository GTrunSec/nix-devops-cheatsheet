{
  description = "Python development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/3a7674c896847d18e598fa5da23d7426cb9be3d2";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    pypi-deps-db = {
      url = "github:DavHau/pypi-deps-db/2205d5a0fc9b691e7190d18ba164a3c594570a4b";
      flake = false;
    };
    mach-nix = { url = "github:DavHau/mach-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, flake-compat, mach-nix, pypi-deps-db }:
    {
      node-packages = import ./node-packages;
    }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          machLib = import mach-nix
            {
              pypiDataRev = pypi-deps-db.rev;
              pypiDataSha256 = pypi-deps-db.narHash;
              python = "python39";
            };

          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.node-packages
              self.overlay
            ];
            config = { };
          };
        in
        rec {

          python-packages-custom = machLib.mkPython rec {
            requirements = ''
              isort
            '';
          };

          devShell = with pkgs; mkShell {
            buildInputs = [
              python-packages-custom
              nodePackages.pyright
              nodePackages.node2nix
            ];
          };

          packages = {
            inherit (pkgs.nodePackages)
              pyright
              node2nix
              ;
            pthon-packages = python-packages-custom;
          };

          hydraJobs = {
            inherit packages;
          };
        }
      )
    ) //
    {
      overlay = final: prev: { };
    };
}
