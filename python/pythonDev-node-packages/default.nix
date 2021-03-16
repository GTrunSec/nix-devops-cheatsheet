final: prev:
let packages = prev.callPackage ./plugins.nix { };
in
{
  nodePackages = prev.nodePackages // packages // { };
}
