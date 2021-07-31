{
  description = "Python development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    pypi-deps-db = {
      url = "github:DavHau/pypi-deps-db/2205d5a0fc9b691e7190d18ba164a3c594570a4b";
      flake = false;
    };
    mach-nix = { url = "github:DavHau/mach-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, flake-compat, mach-nix, pypi-deps-db }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (import ./node-packages)
              self.overlay
            ];
            config = { };
          };
        in
        rec {
          python-packages-custom = pkgs.machlib.mkPython rec {
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
      overlay = final: prev: {
        machlib = import mach-nix
          {
            pypiDataRev = pypi-deps-db.rev;
            pypiDataSha256 = pypi-deps-db.narHash;
            python = "python39";
            pkgs = prev;
          };
      };
    };
}
