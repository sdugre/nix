{
  pkgs,
  config,
  lib,
  ...
}: let
  # Dependencies
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
    });
    systemd.enable = true;
    settings = {
      primary = {
        #mode = "dock";
        layer = "top";
        height = 40;
        margin = "6";
        position = "top";
        output = (lib.head (lib.filter (m: m.primary) config.monitors)).name; # show bar only on primary monitor

        modules-left = [
          "custom/hostname"
          "network"
          "battery"
          #         "tray"
          "cpu"
          "memory"
          "disk"
          "backlight"
          "pulseaudio"
        ];

        modules-center = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];

        modules-right = [
          "tray"
          "clock"
          "custom/power"
        ];

        backlight = {
          device = "intel_backlight";
          format = "{icon}  {percent:3}% ";
          format-icons = ["" ""];
          tooltip = false;
        };

        battery = {
          bat = "BAT0";
          interval = 10;
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format = "{icon} {capacity:2}% ";
          format-charging = "󰂄 {capacity:2}% ";
          on-click = "";
        };

        clock = {
          format = "{:%H:%M}";
          tooltip-format = "{:%Y-%m-%d %a}";
          #''
          # <big>{:%Y %B}</big>
          # <tt><small>{calendar}</small></tt>'';
        };

        cpu = {
          format = "   {usage:2}% ";
        };

        "custom/hostname" = {
          exec = "echo $USER@$HOSTNAME";
          tooltip = false;
        };

        "custom/power" = {
          format = " ";
          on-click = "/home/sdugre/.nix-profile/bin/rofi-logout";
          tooltip = false;
        };

        disk = {
          format = "   {used} ";
        };

        network = {
          interval = 3;
          format-wifi = "   {essid} ";
          format-ethernet = "󰈁 Connected ";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = "";
        };

        memory = {
          format = "󰍛  {:3}%";
          interval = 5;
        };

        pulseaudio = {
          format = "{icon}  {volume:3}%";
          format-muted = "   0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = ["" "" ""];
          };
          on-click = pavucontrol;
        };
      };
    };

    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left
    style = let
#      inherit (config.colorscheme) palette;
      colors = config.lib.stylix.colors;
    in
      /*
      css
      */
      ''
        * {
          font-family: ${config.fontProfiles.regular.family}, ${config.fontProfiles.monospace.family};
          font-size: 14pt;
          padding: 0 8px;
        }
        .modules-right {
          margin-right: -15px;
        }
        .modules-left {
          margin-left: -15px;
        }
        window#waybar.top {
          opacity: 0.95;
          padding: 0;
          background-color: #${colors.base00};
          border: 2px solid #${colors.base0C};
          border-radius: 10px;
        }
        window#waybar.bottom {
          opacity: 0.90;
          background-color: #${colors.base00};
          border: 2px solid #${colors.base0C};
          border-radius: 10px;
        }
        window#waybar {
          color: #${colors.base05};
        }
        #workspaces button {
          background-color: #${colors.base0A};
          color: #${colors.base04};
          margin: 4px;
        }
        #workspaces button.hidden {
          background-color: #${colors.base00};
          color: #${colors.base03};
        }
        #workspaces button.focused,
        #workspaces button.active {
          background-color: #${colors.base0F};
         color: #${colors.base00};
        }

        #clock {
          background-color: #${colors.base0A};
          color: #${colors.base00};
          padding-left: 15px;
          padding-right: 15px;
          margin-top: 0;
          margin-bottom: 0;
          border-radius: 10px;
        }

        #custom-hostname {
          background-color: #${colors.base0A};
          color: #${colors.base00};
          padding-left: 15px;
          padding-right: 18px;
          margin-right: 0;
          margin-top: 0;
          margin-bottom: 0;
          border-radius: 10px;
        }
        #tray {
          color: #${colors.base05};
        }
      '';
  };
}
