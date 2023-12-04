{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "figurine";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/arsham/figurine/releases/download/v${version}/figurine_linux_amd64_v${version}.tar.gz";
    hash = "";
  };

  sourceRoot = ".";

  installPhase = ''
    install -m755 -D ${pname}-v${version} $out/bin/${pname}
  '';

  meta = with lib; {
    homepage = "https://github.com/arsham/figurine";
    description = "Print your name in style";
    platforms = platforms.linux;
  };
}
