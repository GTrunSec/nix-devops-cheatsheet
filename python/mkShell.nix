{
  pkgs ?
    (import <nixpkgs> {}).appendOverlays
    (__attrValues (import ./shell.nix).overlays),
}: let
  my-python-packages = pkgs.callPackage ./poetry {};
in
  pkgs.mkShell {
    packages = with pkgs; [
      #  poetry add py7zr -C ./poetry
      poetry
      my-python-packages
    ];
  }
