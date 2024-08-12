# logout / suspend / reboot / shutdown script for rofi
# ${config.programs.swaylock.package}/bin/swaylock -i ${config.wallpaper} --daemonize
#      swaylock -i ${config.wallpaper} --daemonize
# swaylock --color 0000ff --daemonize
# let wallpaper = config.home-manager.users.sdugre.wallpaper;
{ pkgs, lib, writeShellApplication, rofi, hyprlock, config, ... }: 

(writeShellApplication {
  name = "rofi-logout";
  runtimeInputs = [ rofi hyprlock ];

  text = /* bash */ ''
    choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | rofi -dmenu -i)
    if [[ $choice == "Lock" ]];then
#      swaylock --color 0000ff --daemonize
      hyprlock 
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

