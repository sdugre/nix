# 
{ lib, writeShellApplication, pkgs }: (writeShellApplication {
  name = "test-pkg";
  runtimeInputs = [ ];

  text = /* bash */ ''
    ${pkgs.libnotify}/bin/notify-send "Locking in 10 seconds..."
  '';
}) // {
  meta = with lib; {
    license = licenses.mit;
    platforms = platforms.all;
  };
}
