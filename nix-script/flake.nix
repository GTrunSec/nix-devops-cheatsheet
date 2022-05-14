{
  description = "Nix Script Flake Example";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    nix-script.url = "github:BrianHicks/nix-script";
    nix-script.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {self, ...}:
    {}
    // (
      inputs.flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"]
      (
        system: let
          pkgs = inputs.nixpkgs.legacyPackages.${system}.appendOverlays [
            inputs.nix-script.overlay
          ];
        in {
          apps = {};
          devShell = with pkgs;
            mkShell {
              buildInputs = [];
            };
        }
      )
    )
    // {
      overlay = final: prev: {};
    };
}
