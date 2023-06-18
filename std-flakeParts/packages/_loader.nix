{
  inputs,
  pkgs,
}:
(inputs.flops.lib.configs.haumea.setInit {
  src = ./.;
  loader = inputs.flops.inputs.haumea.lib.loaders.callPackage;
  inputs = builtins.removeAttrs pkgs ["self" "super" "root"];
})
.outputsForTarget "default"
