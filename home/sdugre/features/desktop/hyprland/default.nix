{ lib, inputs, config, pkgs, ... }: {
  imports = [
    ../common
    ../common/wayland-wm
    inputs.hyprland.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    hyprland
    inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      general = {
        gaps_in = 15;
        gaps_out = 20;
        border_size = 2.7;
        cursor_inactive_timeout = 4;
      };
      input = {
        kb_layout = "us";
        touchpad.disable_while_typing = false;
      };
      dwindle.split_width_multiplier = 1.35;
      misc.vfr = "on";

      decoration = {
        active_opacity = 0.94;
        inactive_opacity = 0.84;
        fullscreen_opacity = 1.0;
        rounding = 5;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };
        drop_shadow = true;
        shadow_range = 12;
        shadow_offset = "3 3";
        "col.shadow" = "0x44000000";
        "col.shadow_inactive" = "0x66000000";
      };
      animations = {
        enabled = true;
        bezier = [
          "easein,0.11, 0, 0.5, 0"
          "easeout,0.5, 1, 0.89, 1"
          "easeinback,0.36, 0, 0.66, -0.56"
          "easeoutback,0.34, 1.56, 0.64, 1"
        ];

        animation = [
          "windowsIn,1,3,easeoutback,slide"
          "windowsOut,1,3,easeinback,slide"
          "windowsMove,1,3,easeoutback"
          "workspaces,1,2,easeoutback,slide"
          "fadeIn,1,3,easeout"
          "fadeOut,1,3,easein"
          "fadeSwitch,1,3,easeout"
          "fadeShadow,1,3,easeout"
          "fadeDim,1,3,easeout"
          "border,1,3,easeout"
        ];
      };

      bind = let
        terminal = config.home.sessionVariables.TERMINAL;
        browser = defaultApp "x-scheme-handler/https";
        editor = defaultApp "text/plain";
      in [
        # Program bindings
        "SUPER,Return,exec,${terminal}"
        "SUPER,e,exec,${editor}"
        "SUPER,v,exec,${editor}"
        "SUPER,b,exec,${browser}"
        # Brightness control (only works if the system has lightd)
        ",XF86MonBrightnessUp,exec,light -A 10"
        ",XF86MonBrightnessDown,exec,light -U 10"
        # Volume
#        ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
#        ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
#        ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
#        "SHIFT,XF86AudioMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
#        ",XF86AudioMicMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
        # Screenshotting
#        ",Print,exec,${grimblast} --notify copy output"
#        "SHIFT,Print,exec,${grimblast} --notify copy active"
#        "CONTROL,Print,exec,${grimblast} --notify copy screen"
#        "SUPER,Print,exec,${grimblast} --notify copy window"
#        "ALT,Print,exec,${grimblast} --notify copy area"
        # Tally counter
#        "SUPER,z,exec,${notify-send} -t 1000 $(${tly} time) && ${tly} add && ${gtk-play} -i dialog-information" # Add new entry
#        "SUPERCONTROL,z,exec,${notify-send} -t 1000 $(${tly} time) && ${tly} undo && ${gtk-play} -i dialog-warning" # Undo last entry
#        "SUPERCONTROLSHIFT,z,exec,${tly} reset && ${gtk-play} -i complete" # Reset
#        "SUPERSHIFT,z,exec,${notify-send} -t 1000 $(${tly} time)" # Show current time
      ] ++

#      monitor = map (m: let
#        resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
#        position = "${toString m.x}x${toString m.y}";
#      in
#        "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}"
#      ) (config.monitors);

    # This is order sensitive, so it has to come here.
    extraConfig = ''
      monitor=eDP-1,1920x1080,0x0,1
      # Passthrough mode (e.g. for VNC)
      bind=SUPER,P,submap,passthrough
      submap=passthrough
      bind=SUPER,P,submap,reset
      submap=reset
    '';
  };
}
