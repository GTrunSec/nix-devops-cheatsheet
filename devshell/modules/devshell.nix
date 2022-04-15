{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.devshell;
in {
  options.devshell = {
    name = mkOption {
      type = types.str;
      default = "devshell";
      description = ''
        Name of the shell environment. It usually maps to the project name.
      '';
    };
    shell = mkOption {
      internal = true;
      type = types.package;
      description = "shell Option";
    };
  };

  config.devshell = {
    shell = pkgs.writeScript "${cfg.name}" ''
      echo ${cfg.name};
    '';
  };
}
