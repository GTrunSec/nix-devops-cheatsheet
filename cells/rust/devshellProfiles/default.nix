{
  inputs,
  cell,
}: {
  default = {pkgs, ...}: {
    packages = with pkgs; [
      binutils
      pkgconfig
      openssl
      openssl.dev
    ];
    env = [
      {
        name = "OPENSSL_DIR";
        value = "${pkgs.openssl.bin}/bin";
      }
      {
        name = "PKG_CONFIG_PATH";
        value = "${pkgs.pkg-config}/lib/pkgconfig";
      }
      {
        name = "OPENSSL_INCLUDE_DIR";
        value = "${pkgs.openssl.out.dev}/include";
      }
      {
        name = "OPENSSL_LIB_DIR";
        value = "${pkgs.openssl.out}/lib";
      }
    ];
  };
}
