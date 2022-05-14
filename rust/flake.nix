{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    nix-filter.url = "github:/numtide/nix-filter";
    nix-filter.inputs.nixpkgs.follows = "nixpkgs";

    cheatsheet.url = "github:GTrunSec/cheatsheet";
    cheatsheet.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    (
      flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"] (system: let
        pkgs = nixpkgs.legacyPackages.${system}.appendOverlays [
          self.overlays.default
          inputs.rust-overlay.overlay
          inputs.devshell.overlay
        ];

        craneLib = (inputs.crane.mkLib pkgs).overrideScope' (final: prev: {
          rustc = pkgs.rust-final;
          cargo = pkgs.rust-final;
          rustfmt = pkgs.rust-final;
        });
      in {
        my-crate = craneLib.buildPackage {
          src = ./.;

          # cargoExtraArgs = "--target wasm32-wasi";

          # Tests currently need to be run via `cargo wasi` which
          # isn't packaged in nixpkgs yet...
          doCheck = false;
        };
        packages = {};
        devShells = import ./devshell {inherit inputs pkgs;};
      })
    )
    // {
      overlays = import ./nix/overlays.nix {inherit inputs;};
    };
}
