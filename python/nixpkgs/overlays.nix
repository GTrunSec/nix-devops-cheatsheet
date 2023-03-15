final: prev:
builtins.mapAttrs (n: v:
    prev.callPackage (
      {
        nvfetcher-sources,
        python3Packages,
      }: (python3Packages.buildPythonPackage {
        inherit (v.source) src pname version;
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
    propagatedBuildInputs = [];
  };
}
