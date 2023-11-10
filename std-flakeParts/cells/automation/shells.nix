/*
This file holds reproducible shells with commands in them.

They conveniently also generate config files in their startup hook.
*/
{
  inputs,
  cell,
}: let
  inherit (inputs.std) lib;
  inherit (inputs) std;
  nixpkgs =
    inputs.nixpkgs.appendOverlays
    [];
  l = nixpkgs.lib // builtins;
in {
  # Tool Homepage: https://numtide.github.io/devshell/
  default = lib.dev.mkShell {
    name = "devshell";
    imports = [];
    # Tool Homepage: https://nix-community.github.io/nixago/
    # This is Standard's devshell integration.
    # It runs the startup hook when entering the shell.
    nixago = [
      # inputs.std-ext.preset.nixago.githubsettings
    ];
    commands = [];
  };
}
