{pkgs}: {
  default = with pkgs;
    devshell.mkShell {
      imports = [
        (devshell.importTOML ./commands.toml)
      ];

      packages = [
        pkgs.rust-final
      ];
      env = [
        {
          name = "PKG_CONFIG_PATH";
          value = "${pkgs.pkg-config}/lib/pkgconfig";
        }
        {
          name = "OPENSSL_INCLUDE_DIR";
          value = "${openssl.dev}/include";
        }
        {
          name = "OPENSSL_LIB_DIR";
          value = "${lib.getLib openssl}/lib";
        }
      ];
    };
}
