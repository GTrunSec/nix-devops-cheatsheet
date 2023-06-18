{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "lint-staged";
  version = "13.2.0";

  src = fetchFromGitHub {
    owner = "okonet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s8jlolnYcVdp32lLAk98pxXKZBNJRXQqmf6Xs4fDwmA=";
  };

  npmDepsHash = "sha256-rYVcCt2XueFHsobCt0kah3N4i5mC5TPRJVNUog3ekT8=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Run linters on git staged files";
    homepage = "https://github.com/okonet/lint-staged";
    license = licenses.mit;
  };
}
