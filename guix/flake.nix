{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";
    master.url = "nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    guix-overlay = {
      url = "github:Emiller88/guix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    flake-compat,
    master,
    guix-overlay,
  }:
    {}
    // (
      flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"]
      (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
              guix-overlay.overlay
            ];

            config = {};
          };
        in rec {
          devShell = with pkgs;
            mkShell {
              buildInputs = [
                guile-gnutls
              ];
            };
        }
      )
    )
    // {
      overlay = final: prev: {};
    };
}
