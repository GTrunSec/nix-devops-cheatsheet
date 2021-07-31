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
              emacsPackagesFor = emacs: (
                (prev.emacsPackagesFor emacs).overrideScope'
                  (
                    efinal: eprev:
                      let
                        melpaPackages = eprev.melpaPackages // {
                          my-nix-mode = nix-mode.defaultPackage."${final.system}";
                        };
                      in
                      eprev.override
                        {
                          inherit melpaPackages;
                        }
                  ));
            })
          ];
        };
      let
        emacs-packages = import ./packages.nix { inherit pkgs; };
        emacs-final = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages emacs-packages;
        aux-packages = import ./auxilary.nix { inherit pkgs; };
        all-packages = [ emacs-final ] ++ aux-packages;
      in
      {
        defaultPackage.x86_64-linux = pkgs.buildEnv {
          name = "emacs-plus-aux-packages";
          paths = all-packages;
        };
      };
}
