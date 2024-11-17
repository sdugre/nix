{
  stdenv,
  lib,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "figurine";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/arsham/figurine/releases/download/v${version}/figurine_linux_amd64_v${version}.tar.gz";
    hash = "sha256-5yQw3gyktLRUhJXYA4VvX+wiP0PFmpegv8xxRxDVAyo=";
  };

  sourceRoot = ".";

  installPhase = ''
    install -m755 -D ./deploy/${pname} $out/bin/${pname}
  '';

  meta = with lib; {
    homepage = "https://github.com/arsham/figurine";
    description = "Print your name in style";
    platforms = platforms.linux;
  };
}
