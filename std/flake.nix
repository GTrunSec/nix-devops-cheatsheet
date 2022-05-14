{
  inputs = {
    std.url = "github:divnix/std";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    data-merge.url = "github:divnix/data-merge";
  };
  outputs = {std, ...} @ inputs:
    std.grow {
      inherit inputs;
      cellsFrom = ./cells;
      organelles = [
        (std.functions "library")
        (std.functions "lib")
      ];
    };
}
