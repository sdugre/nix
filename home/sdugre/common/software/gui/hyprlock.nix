{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  font-family = "${config.fontProfiles.regular.family}";
  wallpaper = "${config.wallpaper}";
  nowPlayingScript = pkgs.writeShellScript "hypr-nowplaying" ''
    exec ${playerctl} metadata --format "{{title}}   {{artist}}" 2>/dev/null || echo ""
  '';
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
      };

      auth = {
        "fingerprint:enabled" = true;
        "fingerprint:ready_message" = "(Or scan fingerprint)";
        "fingerprint:present_message" = "Scanning fingerprint...";
        # after install run: 'sudo fprintd-enroll -f right-index-finger [user]'
      };

      background = {
        path = "${wallpaper}";
        blur_passes = 2;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      input-field = {
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        fade_on_empty = false;
        placeholder_text = "Enter password to unlock";
        hide_input = false;
        position = "0, -120";
        halign = "center";
        valign = "center";
      };

      label = [
        # TIME
        {
          text = "cmd[update:1000] date +\"%H:%M\"";
          font_size = 100;
          font_family = "${font-family}";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }

        # USER
        {
          text = "$USER";
          font_size = 24;
          font_family = "${font-family}";
          position = "0, -40";
          halign = "center";
          valign = "center";
        }

        # CURRENT SONG
        {
          text = "cmd[update:1000] ${nowPlayingScript}";
          font_size = 18;
          font_family = "${font-family}";
          position = "0, 0";
          halign = "center";
          valign = "bottom";
        }
      ]
      ++ lib.optionals osConfig.services.fprintd.enable [
        # FINGERPRINT STATUS
        # TODO:  build only if fprintd is enabled
        {
          text = "$FPRINTPROMPT";
          font_size = 16;
          font_family = "${font-family}";
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
