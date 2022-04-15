{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    devshell.url = "/home/gtrun/ghq/github.com/numtide/devshell";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    flake-compat,
    devshell,
  }:
    {}
    // (
      flake-utils.lib.eachDefaultSystem
      (system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlay
            devshell.overlay
          ];
        };
      in rec {
        mkShell = configuration: let
          eval = import ./modules pkgs;
        in
          (eval {inherit configuration;}).shell;
        apps = {
          example = inputs.flake-utils.lib.mkApp {
            exePath = "";
            drv = mkShell {
              name = "2";
            };
          };
        };
      })
    )
    // {
      overlay = final: prev: {};
      budModules = {
        bud = {
          description = "Your highly customizable system ctl";
          category = "devos";
          path = import ./shell/second;
        };
        second = {
          category = "nested commands";
          description = "your second highly customizable clt";
          path = import ./shell/second;
        };
        third = {
          category = "nested commands";
          description = "your third highly customizable clt";
          path = import ./shell/third;
        };
      };
    };
}
