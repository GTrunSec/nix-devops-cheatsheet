{
  description = "haskell-develop";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, flake-compat, rust-overlay }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          pkgs = import nixpkgs {

            inherit system;

            overlays = [
              self.overlay
              (import rust-overlay)
            ];

            config = { };

          };
        in
        rec {
          #haskellPackages = pkgs.haskell.packages.ghc884;
          devShell = with pkgs; mkShell {
            buildInputs = [
              rustracer
            ] ++ [
              rust-bin.stable.latest.rust
              rust-bin.stable.latest.rustc
              rust-bin.stable.latest.cargo
              rust-bin.stable.latest.rust-analysis
              rust-bin.stable.latest.rust-src
              rust-bin.stable.latest.rust-docs
              rust-bin.stable.latest.rust-std
            ];
            RUST_SRC_PATH = "${rust-bin.stable.latest.rust}/lib/rustlib/src/rust/src";
            shellHook = ''
            '';
          };
        }
      )
    ) //
    {
      overlay = final: prev: { };
    };
}
