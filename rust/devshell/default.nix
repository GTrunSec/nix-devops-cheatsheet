{pkgs}: {
  default = with pkgs;
    devshell.mkShell {
      imports = [
        (devshell.importTOML ./commands.toml)
        inputs.code-snippets.${pkgs.system}.rust.devshellProfiles.default
        inputs.code-snippets.${pkgs.system}.main.devshellProfiles.treefmt
      ];

      packages = [
        pkgs.rust-final
      ];
      env = [];
    };
}
