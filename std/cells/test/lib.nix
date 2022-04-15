{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) lib;
  # mapAttrs' = f: set:
  #   lib.listToAttrs (map (attr: f attr set.${attr}) (lib.attrNames set));
in
  {
  }
  // (
    # infinite recursion encountered
    cell.library.mapAttrs' (name: value: lib.nameValuePair ("foo_" + name) ("bar-" + value))
    {
      x = "a";
      y = "b";
    }
  )
