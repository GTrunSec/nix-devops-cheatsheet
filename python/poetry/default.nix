{
  poetry2nix,
  python3,
  ...
}:
poetry2nix.mkPoetryEnv {
  projectDir = ./.;
  preferWheels = true;
  python = python3;
  extraPackages = ps: [
    # ps.python-lsp-server
    # ps.python-lsp-server.passthru.optional-dependencies.all
  ];
}
