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
        height = 32;
        margin = "6";
        position = "top";
        output = (lib.head (lib.filter (m: m.primary) config.monitors)).name; # show bar only on primary monitor

        modules-left = [
          "hyprland/workspaces"
          "custom/arrow10"
          "hyprland/window"
        ];
        modules-right = [
          "custom/arrow9"
          "pulseaudio"
          "custom/arrow8"
          "network"
          "custom/arrow7"
          "memory"
          "custom/arrow6"
          "cpu"
          "custom/arrow5"
          "temperature"
          (if config.device.isLaptop then "custom/arrow4" else "")
          (if config.device.isLaptop then "battery" else "")
          "custom/arrow3"
          "disk"
          "custom/arrow2"
          "tray"
          "clock#date"
          "custom/arrow1"
          "clock#time"
        ];

        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format-time = "{H}:{M:02}";
          format = "{icon} {capacity}% ({time})";
          format-charging = " {capacity}% ({time})";
          format-charging-full = " {capacity}%";
          format-full = "{icon} {capacity}%";
          format-alt = "{icon} {power}W";
          format-icons = [
	      		""
	      		""
	      		""
	      		""
	      		""
          ];
          tooltip = false;
        };

        "clock#time" = {
          interval = 10;
          format = "{:%H:%M}";
          tooltip = false;
        };

        "clock#date" = {
          interval = 20;
          format = "{:%e %b %Y}";
          tooltip = false;
        };

        cpu = {
          interval = 5;
          tooltip = false;
          format = " {usage}%";
          format-alt = " {load}";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "hyprland/language" = {
          format = " {}";
          min-length = 5;
          on-click = "swaymsg 'input * xkb_switch_layout next'";
          tooltip = false;
        };

        disk = {
          format = "   {used} ";
        };

        memory = {
          interval = 5;
          format = " {used:0.1f}G/{total:0.1f}G";
          states = {
            warning = 70;
            critical = 90;
          };
          tooltip = false;
        };

        network = {
          interval = 5;
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ifname}";
          format-disconnected = "No connection";
          format-alt = " {ipaddr}/{cidr}";
          tooltip = false;
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 30;
          tooltip = false;
        };

        "hyprland/workspaces" = {
          disable-scroll-wraparound = true;
          smooth-scrolling-threshold = 4;
          enable-bar-scroll = true;
          format = "{name}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          scroll-step = 1;
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          tooltip = false;
        };

        temperature = {
          critical-threshold = 90;
          hwmon-path = "/sys/class/thermal/thermal_zone${toString config.device.cpuThermalZone}/temp";
          interval = 5;
          format = "{icon} {temperatureC}°";
          format-icons = [
		      	""
		      	""
		      	""
		      	""
		      	""
          ];
          tooltip = false;
        };

        tray = {
          icon-size = 18;
        };

        "custom/arrow1" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow2" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow3" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow4" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow5" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow6" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow7" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow8" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow9" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow10" = {
          format = "";
          tooltip = false;
        };
      };
    };

    style = let
#      inherit (config.colorscheme) palette;
      colors = config.lib.stylix.colors;
      arrow3BG = if config.device.isLaptop then "@battery" else "@temp";
    in
      /*
      css
      */
      ''
        /* Keyframes */
        
        @keyframes blink-critical {
        	to {
        		/*color: @white;*/
        		background-color: @critical;
        	}
        }
        
        
        /* Styles */
        
        /* Colors (gruvbox) */
        @define-color black	#282828;
        @define-color red	#cc241d;
        @define-color green	#98971a;
        @define-color yellow	#d79921;
        @define-color blue	#458588;
        @define-color purple	#b16286;
        @define-color aqua	#689d6a;
        @define-color gray	#a89984;
        @define-color brgray	#928374;
        @define-color brred	#fb4934;
        @define-color brgreen	#b8bb26;
        @define-color bryellow	#fabd2f;
        @define-color brblue	#83a598;
        @define-color brpurple	#d3869b;
        @define-color braqua	#8ec07c;
        @define-color white	#ebdbb2;
        @define-color bg2	#504945;
        
        
        @define-color warning 	@bryellow;
        @define-color critical	@red;
        @define-color mode	@black;
        @define-color unfocused	@bg2;
        @define-color focused	@braqua;
        @define-color inactive	@purple;
        @define-color sound	@brpurple;
        @define-color network	@purple;
        @define-color memory	@braqua;
        @define-color cpu	@green;
        @define-color temp	@brgreen;
        @define-color layout	@bryellow;
        @define-color battery	@aqua;
        @define-color date	@black;
        @define-color time	@white;
        
        /* Reset all styles */
        * {
        	border: none;
        	border-radius: 0;
        	min-height: 0;
        	margin: 0;
        	padding: 0;
        	box-shadow: none;
        	text-shadow: none;
        	icon-shadow: none;
          font-size: 14pt;
        }
        
        /* The whole bar */
        #waybar {
        	background: rgba(40, 40, 40, 0.8784313725); /* #282828e0 */
        	color: @white;
        	font-family: JetBrains Mono, Siji;
        	font-size: 14pt;
        	/*font-weight: bold;*/
        }
        
        /* Each module */
        #battery,
        #clock,
        #cpu,
        #disk,
        #memory,
        #mode,
        #network,
        #pulseaudio,
        #temperature,
        #tray,
        #backlight,
        #idle_inhibitor,
        #disk,
        #user,
        #mpris {
        	padding-left: 8pt;
        	padding-right: 8pt;
        }
        
        /* Each critical module */
        #mode,
        #memory.critical,
        #cpu.critical,
        #temperature.critical,
        #battery.critical.discharging {
        	animation-timing-function: linear;
        	animation-iteration-count: infinite;
        	animation-direction: alternate;
        	animation-name: blink-critical;
        	animation-duration: 1s;
        }
        
        /* Each warning */
        #network.disconnected,
        #memory.warning,
        #cpu.warning,
        #temperature.warning,
        #battery.warning.discharging {
        	color: @warning;
        }
        
        /* And now modules themselves in their respective order */
        
        /* Current sway mode (resize etc) */
        #mode {
        	color: @white;
        	background: @mode;
        }
        
        /* Workspaces stuff */
        #workspaces button {
        	/*font-weight: bold;*/
        	padding-left: 4pt;
        	padding-right: 4pt;
        	color: @white;
        	background: @unfocused;
        }
        
        /* Inactive (on unfocused output) */
        #workspaces button.visible {
        	color: @white;
        	background: @inactive;
        }
        
        /* Active (on focused output) */
        #workspaces button.focused {
        	color: @black;
        	background: @focused;
        }
        
        /* Contains an urgent window */
        #workspaces button.urgent {
        	color: @black;
        	background: @warning;
        }
        
        /* Style when cursor is on the button */
        #workspaces button:hover {
        	background: @black;
        	color: @white;
        }
        
        #window {
        	margin-right: 35pt;
        	margin-left: 35pt;
        }
        
        #pulseaudio {
        	background: @sound;
        	color: @black;
        }
        
        #network {
        	background: @network;
        	color: @white;
        }
        
        #memory {
        	background: @memory;
        	color: @black;
        }
        
        #cpu {
        	background: @cpu;
        	color: @white;
        }
        
        #temperature {
        	background: @temp;
        	color: @black;
        }
        
        #disk {
        	background: @layout;
        	color: @black;
        }
        
        #battery {
        	background: @battery;
        	color: @white;
        }
        
        #tray {
        	background: @date;
        }
        
        #clock.date {
        	background: @date;
        	color: @white;
        }
        
        #clock.time {
        	background: @time;
        	color: @black;
        }
        
        #custom-arrow1 {
        	font-size: 18pt;
        	color: @time;
        	background: @date;
        }
        
        #custom-arrow2 {
        	font-size: 18pt;
        	color: @date;
        	background: @layout;
        }
        
        #custom-arrow3 {
        	font-size: 18pt;
        	color: @layout;
        	background: ${arrow3BG};
        }
        
        #custom-arrow4 {
        	font-size: 18pt;
        	color: @battery;
        	background: @temp;
        }
        
        #custom-arrow5 {
        	font-size: 18pt;
        	color: @temp;
        	background: @cpu;
        }
        
        #custom-arrow6 {
        	font-size: 18pt;
        	color: @cpu;
        	background: @memory;
        }
        
        #custom-arrow7 {
        	font-size: 18pt;
        	color: @memory;
        	background: @network;
        }
        
        #custom-arrow8 {
        	font-size: 18pt;
        	color: @network;
        	background: @sound;
        }
        
        #custom-arrow9 {
        	font-size: 18pt;
        	color: @sound;
        	background: transparent;
        }
        
        #custom-arrow10 {
        	font-size: 18pt;
        	color: @unfocused;
        	background: transparent;
        }
      '';
  };
}
