{
  inputs,
  pkgs,
}:
(inputs.flops.lib.configs.haumea.setInit {
  src = ./.;
  loader = _: path: pkgs.callPackage path {};
})
.outputsForTarget "default"
