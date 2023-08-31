{
  home,
}: let
  inherit (home.sessionVariables) TERMINAL BROWSER;
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
    inactive_opacity = 0.84
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
  bind = SUPER, Space, exec, rofi -show drun -modi drun

  # Basic Binds
  bind = SUPERSHIFT, q, killactive
  bind = SUPERSHIFT, e, exit
  bind = SUPER, s, togglesplit
  bind = SUPER, f, fullscreen, 1
  bind = SUPERSHIFT, f, fullscreen, 0
  bind = SUPERSHIFT, Space, togglefloating

''
