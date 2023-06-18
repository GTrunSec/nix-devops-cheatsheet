{inputs, cell}:
let
 path = inputs.self + "/std-flakeParts/packages/_loader.nix";
in 
import path {inherit inputs; pkgs = inputs.nixpkgs;}
