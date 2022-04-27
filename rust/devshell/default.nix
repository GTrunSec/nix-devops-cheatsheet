{ pkgs }:
{
  default = with pkgs;
    devshell.mkShell {
      imports = [
        ./rust.nix
        (devshell.importTOML ./commands.toml)
      ];
      packages = [];
    };
}
