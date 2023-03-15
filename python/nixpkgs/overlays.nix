final: prev:
builtins.mapAttrs (n: v:
    final.callPackage (
      {
        nvfetcher-sources,
        python3Packages,
      }: (python3Packages.buildPythonPackage {
        inherit (nvfetcher-sources.${n}) src pname version;
        doCheck = false;
        propagatedBuildInputs =
          v.propagatedBuildInputs
          ++ [];
      })
    ) {})
{
  flake8-black = {
    propagatedBuildInputs = [];
  };
  flake8-deprecated = {
    propagatedBuildInputs = [];
  };
  flake8-isort = {
    propagatedBuildInputs = with prev;[ flake8 isort ];
  };
}
