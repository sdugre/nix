{
  pkgs,
  config,
  lib,
  ...
}: let
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  backlight = "${pkgs.backlight}/bin/backlight";

  lockTime = if config.device.isLaptop then 5 * 60 else 15 * 60;
  dimBeforeTime = 10; # seconds before lockTime to dim screen
  suspendAfterTime = 5 * 60; # minutes after lockTime to suspend
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Avoid starting multiple instances of hyprlock.
        lock_cmd = "pidof hyprlock || ${hyprlock} --grace 10";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        # Dim screen
        {
          timeout = lockTime - dimBeforeTime;
          on-timeout = "${pkgs.backlight}/bin/backlight -dec 20";
          on-resume = "${pkgs.backlight}/bin/backlight -inc 20";
        }
        # Lock screen
        {
          timeout = lockTime;
          on-timeout = "loginctl lock-session";
          on-resume = "startup-reminder";
        }
        # Mute Mic
        {
          timeout = lockTime + 10;
          on-timeout = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
          on-resume = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
        }
        # Suspend
        {
          timeout = lockTime + suspendAfterTime;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
