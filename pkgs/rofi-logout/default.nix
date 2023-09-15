# logout / suspend / reboot / shutdown script for rofi

{ lib, writeShellApplication, rofi }: (writeShellApplication {
  name = "rofi-logout";
  runtimeInputs = [ rofi ];
  text = builtins.readFile ./rofi-logout.sh;
}) // {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
