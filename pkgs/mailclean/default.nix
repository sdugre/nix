{ lib
, fetchurl
, appimageTools
, makeDesktopItem
}:

let
  pname = "mailclean";
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/ravimehra9911/mailclean/releases/download/v${version}/MailClean-linux-x86_64.AppImage";
    hash = "sha256:29508b356a7427affb2908bd34bbbc9f4ba6cfd0ca628c5412a352e461f3697a";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "MailClean";
    comment = "Clean up your email inbox";
    exec = pname;
    icon = "mail-message-new";
    terminal = false;
    categories = [ "Network" "Email" ];
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm644 \
      ${desktopItem}/share/applications/${pname}.desktop \
      $out/share/applications/${pname}.desktop
  '';

  meta = {
    description = "Email inbox cleanup tool";
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
