{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    devshell.url = "github:numtide/devshell";
    bud = {
      #url = "path:/home/gtrun/ghq/github.com/GTrunSec/bud";
      url = "github:gtrunsec/bud/extend";
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
        devShell =
          let
            eval = import "${devshell}/modules" pkgs;
            configuration = {
              name = pkgs.lib.mkDefault "devshell";
              imports =
                let
                  devshell = import ./shell { inherit self inputs pkgs; };
                in
                devshell.modules ++ devshell.exportedModules;
            };
          in
          (eval {
            inherit configuration;
            extraSpecialArgs = { inherit self inputs; };
          }).shell;
      })
    ) //
    {
      overlay = final: prev: { };
      budModules = {
        bud = { description = "Your highly customizable system ctl"; category = "devos"; path = import ./shell/second; };
        second = { category = "nested commands"; description = "your second highly customizable clt"; path = import ./shell/second; };
        third = { category = "nested commands"; description = "your third highly customizable clt"; path = import ./shell/third; };
      };
    };
}
