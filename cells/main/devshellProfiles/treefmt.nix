{
  pkgs,
  lib,
  ...
}: let
  withCategory = category: attrset: attrset // {inherit category;};
in {
  commands = [
    (withCategory "hexagon" {package = pkgs.treefmt;})
  ];
  packages = with pkgs; [
    # formatters
    alejandra
    nodePackages.prettier
    nodePackages.prettier-plugin-toml
    shfmt
  ];

  devshell.startup.nodejs-setuphook =
    lib.stringsWithDeps.noDepEntry
    ''
      export NODE_PATH=${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules:$NODE_PATH
    '';
}
