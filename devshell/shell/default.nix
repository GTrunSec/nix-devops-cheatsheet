{ self, inputs, pkgs, ... }:
{
  modules = with inputs; [
    bud.devshellModules.bud
  ];
  exportedModules = [
    (pkgs.devshell.importTOML ./test.toml)
  ];
}
