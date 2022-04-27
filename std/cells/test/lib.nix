{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) lib;
  inherit (cell) library;
  # mapAttrs' = f: set:
  #   lib.listToAttrs (map (attr: f attr set.${attr}) (lib.attrNames set));
  a = (library.mapAttrs' (name: value: lib.nameValuePair ("foo_" + name) ("bar-" + value))
    {
      x = "a";
      y = "b";
    });

in
  {

  }
