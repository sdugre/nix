{
  home, 
  wallpaper,
  pkgs,
}: let   
  inherit (home.sessionVariables) TERMINAL BROWSER;
  grimblast = "${pkgs.inputs.hyprland-contrib.grimblast}/bin/grimblast";
in ''
  # ASCII Art from https://fsymbols.com/generators/carty/
  monitor=eDP-1,1920x1080,0x0,1

  input {
    kb_layout = us
    touchpad {
      disable_while_typing=false
    }
  }

  general {
    gaps_in = 3
    gaps_out = 5
    border_size = 2
  }

  decoration {
    active_opacity = 0.94
    inactive_opacity = 0.75
    fullscreen_opacity = 1.0
    rounding=5
    drop_shadow = true
    shadow_range = 12
    shadow_offset = [3 3]
    col.shadow = 0x44000000
    col.shadow_inactive = 0x66000000
  }
  $notifycmd = notify-send -h string:x-canonical-private-synchronous:hypr-cfg -u low
  # █▀ █░█ █▀█ █▀█ ▀█▀ █▀▀ █░█ ▀█▀ █▀
  # ▄█ █▀█ █▄█ █▀▄ ░█░ █▄▄ █▄█ ░█░ ▄█
  bind = SUPER, Return, exec, ${TERMINAL}
  bind = SUPER, b, exec, ${BROWSER}
  bind = SUPER, Space, exec, rofi -modes "drun,window,run" -show drun
  bind = SUPER, d, exec, nautilus &
  bind = SUPER, l, exec, /home/sdugre/.nix-profile/bin/rofi-logout

  # Basic Binds
  bind = SUPER, q, killactive
  bind = SUPERSHIFT, e, exit	
  bind = SUPER, s, togglesplit
  bind = SUPER, f, fullscreen, 1
  bind = SUPERSHIFT, f, fullscreen, 0
  bind = SUPERSHIFT, Space, togglefloating
  # Mouse Binds
  bindm=SUPER, mouse:272, movewindow
  bindm=SUPER, mouse:273, resizewindow
  # Switch workspaces with mainMod + [0-9]
  bind = SUPER, 1, workspace, 1
  bind = SUPER, 2, workspace, 2
  bind = SUPER, 3, workspace, 3
  bind = SUPER, 4, workspace, 4
  bind = SUPER, Tab, workspace, e+1
 # Move active window to a workspace with mainMod + SHIFT + [0-9]
  bind = SUPER SHIFT, 1, movetoworkspace, 1
  bind = SUPER SHIFT, 2, movetoworkspace, 2
  bind = SUPER SHIFT, 3, movetoworkspace, 3
  bind = SUPER SHIFT, 4, movetoworkspace, 4
  # Scroll through existing workspaces with mainMod + scroll
  bind = SUPER, mouse_down, workspace, e+1
  bind = SUPER, mouse_up, workspace, e-1
  # Brightness control (only works if the system has lightd)
  bind =, XF86MonBrightnessUp, exec, backlight -inc 5
  bind =, XF86MonBrightnessDown, exec, backlight -dec 5
  # Volume
  # Example volume button that allows press and hold, volume limited to 150%
  bindle=, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
  bindle=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  bindl=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  # Screenshots
  bind = , Print , exec, ${grimblast} --notify --freeze copy output
  bind = SHIFT, Print, exec, ${grimblast} --notify --freeze copy active
  bind = CONTROL, Print, exec, ${grimblast} --notify --freeze copy screen
  bind = SUPER, Print, exec, ${grimblast} --notify --freeze copy area
  bind = ALT, Print, exec, ${grimblast} --notify --freeze copy area
  # Auto Start
  exec-once = mako &
  exec-once = swaybg -i ${wallpaper} --mode fill &
''
