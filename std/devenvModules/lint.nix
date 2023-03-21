# Start devenv Module here
{
  pkgs,
  self,
  ...
}: {
  packages = with pkgs; [
    self.packages.${pkgs.system}.lint-staged
  ];
  env = {
  };
}
