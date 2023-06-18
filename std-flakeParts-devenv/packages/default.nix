{
  pkgs,
  inputs',
}: {
  lint-staged = pkgs.callPackage ./lint-staged.nix {};
}
