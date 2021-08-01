{
  description = "Emacs Flakes";
  nixConfig.extra-experimental-features = "nix-command flakes ca-references";
  nixConfig.extra-substituters = "https://emacsng.cachix.org";
  nixConfig.extra-trusted-public-keys = "emacsng.cachix.org-1:i7wOr4YpdRpWWtShI8bT6V7lOTnPeI7Ho6HaZegFWMI=";

  inputs = {
    nixpkgs = { url = "nixpkgs/release-21.05"; };
    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
    };
    nix-mode = { url = "github:NixOS/nix-mode"; };
    emacs-ng = { url = "github:emacs-ng/emacs-ng"; };
  };

  outputs =
    { self
    , nixpkgs
    , emacs-overlay
    , nix-mode
    , emacs-ng
    }:
      with import nixpkgs
        {
          system = "x86_64-linux";
          overlays = [
            emacs-overlay.overlay
            (final: prev: {
              emacsNg = emacs-ng.defaultPackage."${final.system}";

              emacsPackagesFor = emacs: (
                (prev.emacsPackagesFor emacs).overrideScope' (
                  eself: esuper:
                    let
                      melpaPackages = esuper.melpaPackages // {
                        nix-mode = esuper.nix-mode.overrideAttrs (old: {
                          src = "${nix-mode}";
                        });
                      };
                      manualPackages = esuper.manualPackages // {
                        clip2org = esuper.trivialBuild {
                          pname = "clip2org";
                          version = "2021-06-11";
                          src = prev.fetchFromGitHub {
                            owner = "acowley";
                            repo = "clip2org";
                            rev = "e80616a98780f37c7cc87baefd38ad2180f8a98f";
                            sha256 = "sha256:1h3fbblhdb0hrrk0cl0j8wcf4x0z0wma971ahl79m9g9394yvfps";
                          };
                        };
                      };
                      epkgs = esuper.override {
                        inherit manualPackages melpaPackages;
                      };
                    in
                    epkgs
                ));
            })
          ];
        };
      let
        emacs-packages = import ./packages.nix { inherit pkgs; };
        emacs-final = (pkgs.emacsPackagesFor (pkgs.emacsNg.overrideAttrs (old: {
          #withWebrender = true;
        }))).emacsWithPackages emacs-packages;
        aux-packages = import ./auxilary.nix {
          inherit pkgs;
        };
        all-packages = [ emacs-final ] ++ aux-packages;
      in
      {
        defaultPackage.x86_64-linux = pkgs.buildEnv {
          name = "emacs-plus-aux-packages";
          paths = all-packages;
        };
      };
}
