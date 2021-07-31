{
  description = "Emacs Flakes";

  inputs = {
    nixpkgs = { url = "nixpkgs/release-21.05"; };
    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
    };
    nix-mode = { url = "github:NixOS/nix-mode"; };
  };

  outputs =
    { self
    , nixpkgs
    , emacs-overlay
    , nix-mode
    }:
      with import nixpkgs
        {
          system = "x86_64-linux";
          overlays = [
            emacs-overlay.overlay
            (final: prev: {
              myEmacsPackageOverrides = self: super:
                let
                  melpaPackages = super.melpaPackages // {
                    my-nix-mode = super.nix-mode.overrideAttrs (old: {
                      src = "${nix-mode}";
                    });
                  };
                  manualPackages = super.manualPackages // {
                    # my-nix-mode = super.trivialBuild {
                    #   pname = "nix-mode-flake";
                    #   src = "${nix-mode}";
                    #   packageRequires = with super;[
                    #     f
                    #     mmm-mode
                    #     org-plus-contrib
                    #     company
                    #   ];
                    # };
                  };
                in
                super.override {
                  inherit manualPackages melpaPackages;
                };

              myEmacsPackages = epkgs: with epkgs; [ melpaPackages.my-nix-mode ];
              myEmacs = ((final.emacsPackagesFor final.emacs).overrideScope' final.myEmacsPackageOverrides).emacsWithPackages
                final.myEmacsPackages;
            })
          ];
        };
      let
        emacs-packages = import ./packages.nix { inherit pkgs; };
        #emacs-final = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages emacs-packages;
        emacs-final = pkgs.myEmacs;

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
