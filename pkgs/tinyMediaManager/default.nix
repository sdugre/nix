# THIS DOESN'T WORK

{ stdenv, lib 
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "tinyMediaManager";
  version = "4.3.14";

  src = fetchurl {
    url = "https://release.tinymediamanager.org/v4/dist/tmm_${version}_linux-amd64.tar.gz";
    hash = "sha256-1uWm89liPCvpvnBCn/yJL87miLOaKG4T6nc+2f3ApIc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  sourceRoot = ".";

  installPhase = ''
#    install -m755 -D ./${pname}/${pname} $out/bin/${pname}
    cp -a ./${pname}/${pname} $out/bin/${pname}
  '';

  meta = with lib; {
    homepage = "https://www.tinymediamanager.org";
    description = "A multi-OS media management tool";
    platforms = platforms.linux;
  };
}
