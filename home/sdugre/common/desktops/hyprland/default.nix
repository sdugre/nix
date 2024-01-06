{ lib, inputs, config, pkgs, ... }: {
  imports = [
    inputs.hyprland.homeManagerModules.default
   
    # wayland stuff necessary for hyprland
    ../../software/gui/gtk.nix
    ../../software/gui/kitty.nix
    ../../software/gui/mako.nix
    ../../software/gui/rofi.nix
    ../../software/gui/swayidle.nix
    ../../software/gui/swaylock.nix
    ../../software/gui/waybar.nix

  ];

#  xdg.portal.config.common.default = "*";   

  home.packages = with pkgs; [
    inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    rofi-logout    # personal logout script
    swaybg         # wallpaper utility
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      # Same as default, but stop graphical-session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };    
    
    settings = {
      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;
        cursor_inactive_timeout = 4;
        "col.active_border" = "0xff${config.colorscheme.colors.base0C}";
        "col.inactive_border" = "0xff${config.colorscheme.colors.base02}";
      };
      group = {
        "col.border_active" = "0xff${config.colorscheme.colors.base0B}";
        "col.border_inactive" = "0xff${config.colorscheme.colors.base04}";
        groupbar = {
          font_size = 11;
        };
      };
      input = {
        kb_layout = "us";
        touchpad.disable_while_typing = false;
      };    
      decoration = {
        active_opacity = 0.94;
        inactive_opacity = 0.75;
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

      exec-once = [
        "${config.services.mako.package}/bin/makoctl &"
        "${pkgs.swaybg}/bin/swaybg -i ${config.wallpaper} --mode fill &"
      ];
      
      bind = let
        swaylock = "${config.programs.swaylock.package}/bin/swaylock";
      #  playerctl = "${config.services.playerctld.package}/bin/playerctl";
      #  playerctld = "${config.services.playerctld.package}/bin/playerctld";
        makoctl = "${config.services.mako.package}/bin/makoctl";
        rofi = "${config.programs.rofi.package}/bin/rofi";
        rofi-logout = "${pkgs.rofi-logout}/bin/rofi-logout";
        grimblast = "${pkgs.grimblast}/bin/grimblast";
        pactl = "${pkgs.pulseaudio}/bin/pactl";
        notify-send = "${pkgs.libnotify}/bin/notify-send";
        backlight = "${pkgs.backlight}/bin/backlight";
        gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
        xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
        defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

        terminal = config.home.sessionVariables.TERMINAL;
        browser = defaultApp "x-scheme-handler/https";
        editor = defaultApp "text/plain";
      in [
        # Program bindings
        "SUPER,Return,exec,${terminal}"
        "SUPER,e,exec,${editor}"
        "SUPER,v,exec,${editor}"
        "SUPER,b,exec,${browser}"
        "SUPER, Space, exec, ${rofi} -modes \"drun,window,run\" -show drun"
        "SUPER, d, exec, nautilus &"
#        "SUPER, l, exec, /home/sdugre/.nix-profile/bin/rofi-logout"
        "SUPER, l, exec, ${rofi-logout}"
        # Basic Binds
        "SUPER, q, killactive"
        "SUPERSHIFT, e, exit"
        "SUPER, s, togglesplit"
        "SUPER, f, fullscreen, 1"
        "SUPERSHIFT, f, fullscreen, 0"
        "SUPERSHIFT, Space, togglefloating"
        # Switch workspaces with mainMod + [0-9]
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, Tab, workspace, e+1"
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        # Scroll through existing workspaces with mainMod + scroll
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
        # Brightness control (custom script)
        ", XF86MonBrightnessUp, exec, ${backlight} -inc 5"
        ", XF86MonBrightnessDown, exec, ${backlight} -dec 5"
        # Screenshots
        ", Print , exec, ${grimblast} --notify --freeze copy output"
        "SHIFT, Print, exec, ${grimblast} --notify --freeze copy active"
        "CONTROL, Print, exec, ${grimblast} --notify --freeze copy screen"
        "SUPER, Print, exec, ${grimblast} --notify --freeze copy area"
        "ALT, Print, exec, ${grimblast} --notify --freeze copy area"
      ]; 

      bindm = [
        # Mouse Binds
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

        # Volume
        # Example volume button that allows press and hold, volume limited to 150%
      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];
      bindl = let
        swaylock = "${config.programs.swaylock.package}/bin/swaylock";
      in [ 
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", switch:on:Lid Switch, exec, ${swaylock} -i ${config.wallpaper}"
      ];
      monitor = [ "eDP-1,1920x1080,0x0,1" ];
    };
  };
}
