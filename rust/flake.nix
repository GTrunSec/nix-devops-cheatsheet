{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/7d71001b796340b219d1bfa8552c81995017544a";
    master.url = "nixpkgs";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, flake-compat, master, rust-overlay }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          unstable = final: prev: {
            inherit ((import inputs.master) { inherit system; })
              rustracer;
          };

          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
              (import rust-overlay)
              unstable
            ];

            config = { };

          };
        in
        rec {
          packages = {
            inherit (pkgs.rust-bin.stable.latest)
              rust
              rustc
              cargo
              rust-analysis
              rust-src
              rust-std
              rust-docs;
            inherit (pkgs)
              rustracer;
          };
          devShell = with pkgs;
            mkShell {
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
        })
    ) //
    {
      overlay = final: prev: { };
    };
}
