{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    devshell.url = "github:numtide/devshell";
    bud = {
      url = "github:GTrunSec/bud/custom";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.devshell.follows = "devshell";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils
    , flake-compat
    , devshell
    , bud
    }:
    { }
    //
    (flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlay
            devshell.overlay
          ];
        };
      in
      rec {
        reboudBud = bud self;
        devShell = with pkgs; pkgs.devshell.mkShell {
          imports = [ ];
          commands = [
            {
              category = "devos";
              package = reboudBud {
                inherit pkgs;
                name = "bud";
              };
            }
            {
              category = "devos";
              package = reboudBud {
                inherit pkgs;
                name = "second";
                description = "Your second highly customizable system ctl";
                budStdProfile = false;
              };
            }
            {
              category = "devos";
              package = reboudBud {
                inherit pkgs;
                name = "third";
                description = "Your third customizable system ctl";
                budStdProfile = false;
              };
            }
          ];
        };
      })
    ) //
    {
      overlay = final: prev: { };
      budModules = {
        bud = import ./shell/bud;
        second = import ./shell/second;
        third = import ./shell/third;
      };
    };
}
