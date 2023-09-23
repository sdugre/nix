# logout / suspend / reboot / shutdown script for rofi

{ pkgs, lib, writeShellApplication, rofi, config, ... }: 

#let
#  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
#in
(writeShellApplication {
  name = "rofi-logout";
  runtimeInputs = [ rofi ];

  text = /* bash */ ''
    choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | rofi -dmenu -i)
    if [[ $choice == "Lock" ]];then
      echo "Can't do that"
    elif [[ $choice == "Logout" ]];then
      pkill -KILL -u "$USER"
    elif [[ $choice == "Suspend" ]];then
      systemctl suspend
    elif [[ $choice == "Reboot" ]];then
      systemctl reboot
    elif [[ $choice == "Shutdown" ]];then
      systemctl poweroff
    fi
  '';

}) // {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}

