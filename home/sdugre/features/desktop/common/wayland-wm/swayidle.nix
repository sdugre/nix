{ pkgs, lib, config, ... }:

let 
  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  backlight = "${pkgs.backlight}/bin/backlight";
  notify = "${pkgs.libnotify}/bin/notify-send";

  lockTime = 5 * 60; # TODO: configurable desktop (10 min)/laptop (4 min)
  dimBeforeTime = 10; # seconds before lockTime to dim screen
  suspendAfterTime = 5 * 60; # minutes after lockTime to suspend 

in
{
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    timeouts = [
      # Dim screen
      {
        timeout = lockTime - dimBeforeTime;
        command = "${pkgs.test-pkg}/bin/test-pkg"; 
#        command = "${notify} 'GOING TO SLEEP'";
        resumeCommand = "${pkgs.backlight}/bin/backlight -inc 20";
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
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
