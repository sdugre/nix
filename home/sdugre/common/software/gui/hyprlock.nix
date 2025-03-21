{
  config,
  pkgs,
  ...
}: let
#  inherit (config.colorscheme) palette;
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  font-family = "${config.fontProfiles.regular.family}";
  wallpaper = "${config.wallpaper}";
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 10;
        pam_module = "hyprlock"; # Set up in system config
      };

      background = {
        path = "${wallpaper}";
        blur_passes = 2;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      #      image = {
      #        path = "${./face.jpg}";
      #        size = 120;
      #        rounding = -1; # Circle
      #        border_size = 4;
      #        border_color = "rgba(255, 255, 255, 0.6)";
      #        position = "0, 100";
      #        halign = "center";
      #        valign = "center";
      #      };

      input-field = {
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
#        outer_color = "rgba(0, 0, 0, 0)";
#        inner_color = "rgba(0, 0, 0, 0.5)";
#        font_color = "rgb(200, 200, 200)";
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
#          color = "rgba(255, 255, 255, 0.9)";
          font_size = 100;
          font_family = "${font-family}";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }

        # USER
        {
          text = "$USER";
#          color = "rgba(255, 255, 255, 0.6)";
          font_size = 20;
          font_family = "${font-family}";
          position = "0, -40";
          halign = "center";
          valign = "center";
        }

        # CURRENT SONG
        {
          text = "cmd[update:1000] ${playerctl} metadata --format '{{title}}   {{artist}}'";
#          color = "rgba(255, 255, 255, 0.6)";
          font_size = 18;
          font_family = "${font-family}";
          position = "0, 0";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
