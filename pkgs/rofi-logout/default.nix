# logout / suspend / reboot / shutdown script for rofi
# ${config.programs.swaylock.package}/bin/swaylock -i ${config.wallpaper} --daemonize
#      swaylock -i ${config.wallpaper} --daemonize

{ pkgs, lib, writeShellApplication, rofi, swaylock, config, ... }: 

(writeShellApplication {
  name = "rofi-logout";
  runtimeInputs = [ rofi swaylock ];

  text = /* bash */ ''
    choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | rofi -dmenu -i)
    if [[ $choice == "Lock" ]];then
      swaylock --color 0000ff --daemonize
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

