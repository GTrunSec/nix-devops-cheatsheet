{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    devshell.url = "github:numtide/devshell";
    yants.url = "github:divnix/yants";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils
    , devshell
    , yants
    }:
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system}.appendOverlays [ devshell.overlay ];
      in
      rec {
        inherit yants;
        someType = with inputs.yants "std"; enum "red" [ "red" ];
        #{ n = { a = "A"; b = "B"}; f = { c = "C"; d = "D"};} => { "n+a" = "A"; "n+b" = "B"; "f+c" = "C"; "f+d" = "D";}

        b  = let f = x: lib.foldr (n: acc: acc // lib.mapAttrs' (n': lib.nameValuePair (n+"-"+n') ) (x.${n}) ) {} (lib.attrNames x); in f;

        a = with pkgs.lib; let
          b = (f: mapAttrs (name: value: f) f) { n = { a = "A"; b = "B";}; f = { c = "C"; d = "D";};};
          in
            b;
        b = with pkgs.lib; let
          b = (f: mapAttrs (name: value: name + value) f) { n = "1"; f = "2";};
          in
            b;
      })
    ) //
    {
      overlay = final: prev: {};
    };
}
