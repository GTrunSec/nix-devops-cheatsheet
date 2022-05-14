{
  description = "Nix: Coding development environment";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {self, ...} @ inputs:
    inputs.flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {})
    // {
      templates = {
        rust = {
          description = "Rust Environment";
          path = ./rust;
        };
        emacs = {
          description = "Emacs Environment";
          path = ./emacs;
        };
      };
    };
}
