# 
{ lib, writeShellApplication, pkgs }: (writeShellApplication {
  name = "test-pkg";
  runtimeInputs = [ ];

  text = /* bash */ ''
    ${pkgs.libnotify}/bin/notify-send 'test-pkg output';
  '';
}) // {
  meta = with lib; {
    license = licenses.mit;
    platforms = platforms.all;
  };
}
