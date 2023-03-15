{
  poetry2nix,
  python3,
  ...
}:
poetry2nix.mkPoetryEnv {
  projectDir = ./.;
  preferWheels = true;
  python = python3;
  # overrides = import ./overrides-preferWheels.nix poetry2nix;
  extraPackages = ps: [
    # ps.python-lsp-server
    # ps.python-lsp-server.passthru.optional-dependencies.all
  ];
}
