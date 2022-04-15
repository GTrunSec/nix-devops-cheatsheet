{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) lib;
in {
  mapAttrs' = f: set:
    lib.listToAttrs (map (attr: f attr set.${attr}) (lib.attrNames set));
}
