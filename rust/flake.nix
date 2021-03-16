{
  description = "haskell-develop";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs";
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, rust-overlay }:
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
            ];

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
