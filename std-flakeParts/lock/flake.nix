{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/96f6f7c7fc7da4d3effb7f059a441634f42bea12";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
  };
  outputs = _: {};
}
