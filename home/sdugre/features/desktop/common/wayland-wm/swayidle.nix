{ pkgs, lib, config, ... }:

let
  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  backlight = "${pkgs.backlight}/bin/backlight";

  isLocked = "${pgrep} -x ${swaylock}";
  lockTime = 1 * 60; # TODO: configurable desktop (10 min)/laptop (4 min)
  dimBeforeTime = 10; # seconds before lockTime to dim screen
  suspendAfterTime = 1 * 60; # minuts after lockTime to suspend 

in
{
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    timeouts = [
      # Dim screen
      {
        timeout = lockTime - dimBeforeTime;
        command = "${backlight} -dec 20";
        resumeCommnad = "${backlight} -inc 20";
      } 
      # Lock screen
      {
        timeout = lockTime;
        command = "${swaylock} -i ${config.wallpaper} --daemonize";
      }
      # Mute Mic
      {
        timeout = lockTime + 10;
        command = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
        resumeCommand = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";        
      }
      # Suspend
      {
        timeout = lockTime + suspendAfterTime;
        command = "systemctl suspend";
      }
    ]
  };
}
