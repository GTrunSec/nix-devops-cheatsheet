poetry2nix: let
  postOverlay = final: prev: let
    addNativeBuildInputs = drvName: inputs: {
      "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
      });
    };
    unpackSource = source:
      prev.pkgs.runCommand "orjson-src" {
        src = source;
      } ''
        mkdir -p $out
        tar -zxf $src -C $out --strip-components=1
      '';
  in
    {
      orjson = prev.orjson.overridePythonAttrs (old: {
        cargoDeps = with old;
          prev.pkgs.rustPlatform.importCargoLock {
            lockFile = "${unpackSource old.src}/Cargo.lock";
          };
      });
      cryptography = prev.cryptography.overridePythonAttrs (old: {
        cargoDeps = with old;
          prev.pkgs.rustPlatform.importCargoLock {
            lockFile = "${unpackSource old.src}/src/rust/Cargo.lock";
          };
      });
    }
    // addNativeBuildInputs "coolname" [final.setuptools];

  preOverlay = final: prev: {
    wheel = prev.wheel.override {preferWheel = false;};

    # disable wheel for these packages, because they will require a rust dependency
    cryptography = prev.cryptography.override {
      preferWheel = false;
    };
    orjson = prev.orjson.override {
      preferWheel = false;
    };
  };
in
  [preOverlay poetry2nix.defaultPoetryOverrides postOverlay]
