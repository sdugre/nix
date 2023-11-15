# 
{ lib, writeShellApplication, pkgs }: (writeShellApplication {
  name = "test-pkg";
  runtimeInputs = [ ];

  text = /* bash */ ''
    ${pkgs.libnotify}/bin/notify-send "USER is $(whoami)"
    brillo -U 15
  '';
}) // {
  meta = with lib; {
    license = licenses.mit;
    platforms = platforms.all;
  };
}
