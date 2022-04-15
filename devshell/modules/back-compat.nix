{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  options = {
    name = mkOption {
      internal = true;
      type = types.nullOr types.str;
      default = null;
    };
  };

  # Copy the values over to the devshell module
  config.devshell =
    {}
    // (lib.optionalAttrs (config.name != null) {name = config.name;});
}
