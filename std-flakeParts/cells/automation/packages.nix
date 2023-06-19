{
  inputs,
  cell,
}: let
  path = inputs.self + "/packages/_loader.nix";
in
  import path {
    inherit inputs;
    pkgs = inputs.nixpkgs;
  }
