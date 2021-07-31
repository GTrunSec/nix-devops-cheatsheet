final: prev:
let packages = prev.callPackage ./plugins.nix { nodejs = prev.nodejs-14_x; };
in
{
  nodePackages = prev.nodePackages // packages // { };
}
