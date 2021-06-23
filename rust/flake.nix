{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    devshell-flake.url = "github:numtide/devshell";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils
    , flake-compat
    , rust-overlay
    , devshell-flake
    }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
      let
        # unstable = final: prev: {
        #   inherit ((import inputs.master) { inherit system; })
        #     rustracer;
        # };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlay
            rust-overlay.overlay
            devshell-flake.overlay
            #unstable
          ];

          config = { };

        };
      in
      rec {
        packages = {
          inherit (pkgs.rust-bin.nightly.latest)
            default
            rust-analyzer-preview;
          inherit (pkgs)
            rustracer;
        };
        devShell = with pkgs; devshell.mkShell {
          imports = [
            ./nix/rust.nix
            (devshell.importTOML ./nix/commands.toml)
          ];
          packages = [
          ];
        };
      })
    ) //
    {
      overlay = final: prev: {
        rust-final = final.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" ];
        };
      };
    };
}
