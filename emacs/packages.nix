{pkgs}: epkgs:
(with epkgs.melpaPackages; [
  nix-mode
])
++ (with epkgs.manualPackages; [
  clip2org
])
