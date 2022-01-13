{
  description = "Emacs development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
    };
    nix-mode = { url = "github:NixOS/nix-mode"; };
    emacs-ng = { url = "github:emacs-ng/emacs-ng"; };
    emacs-darwin.url = "github:cmacrae/emacs";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils
    , flake-compat
    , emacs-overlay
    , emacs-ng
    , emacs-darwin
    , nix-mode
    }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            emacs-overlay.overlay
            self.overlay
            emacs-darwin.overlay
          ];
          config = { allowUnsupportedSystem = true; };
        };
        emacs-packages = import ./packages.nix { inherit pkgs; };
        aux-packages = import ./auxilary.nix {
          inherit pkgs;
        };

        emacsng-final = (pkgs.emacsPackagesFor (pkgs.emacsNg.overrideAttrs (old: {
          #withWebrender = true;
        }))).emacsWithPackages emacs-packages;
        emacs-final = (pkgs.emacsPackagesFor (pkgs.emacs.overrideAttrs (old: {
          #withWebrender = true;
        }))).emacsWithPackages emacs-packages;
        all-packages = [ ] ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [ emacsng-final ]) ++
        (pkgs.lib.optionals pkgs.stdenv.isDarwin [ emacs-final ]) ++
        aux-packages;
      in
      {
        defaultPackage = pkgs.buildEnv {
          name = "emacs-plus-aux-packages";
          paths = all-packages;
        };
      }
      )
    ) //
    {
      overlay = final: prev: {

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
      };
    };
}
