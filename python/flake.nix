{
  description = "python-develop";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/3a7674c896847d18e598fa5da23d7426cb9be3d2";
    mach-nix = { url = "github:DavHau/mach-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, mach-nix }:
    {
      python-dev-node-packages = import ./pythonDev-node-packages;
    }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          machLib = import mach-nix
            {
              pypiDataRev = "2205d5a0fc9b691e7190d18ba164a3c594570a4b";
              pypiDataSha256 = "1aaylax7jlwsphyz3p73790qbrmva3mzm56yf5pbd8hbkaavcp9g";
              python = "python39";
            };
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.python-dev-node-packages
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
        }
      )
    ) //
    {
      overlay = final: prev: { };
    };
}
