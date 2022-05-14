{
  inputs = {
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    data-merge.url = "github:divnix/data-merge";
  };
  outputs = {std, ...} @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./cells;
      organelles = [
        (std.functions "library")
        (std.devshells "devshells")
        (std.functions "devshellProfiles")
      ];
    } {
      devShells = inputs.std.harvest inputs.self ["main" "devshells"];
    } {
      templates = {
        rust = {
          description = "Rust Environment";
          path = ./rust;
        };
        emacs = {
          description = "Emacs Environment";
          path = ./emacs;
        };
        go = {
          description = "Go Environment";
          path = ./go
          ;
        };
      };
    };
}
