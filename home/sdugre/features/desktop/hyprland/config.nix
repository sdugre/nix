{
  home,
  colorscheme,
  wallpaper,
}: let
  inherit (home.sessionVariables) TERMINAL BROWSER;
in ''
  # ASCII Art from https://fsymbols.com/generators/carty/
  input {
    kb_layout = gb
    touchpad {
      disable_while_typing=false
    }
  }

  general {
    gaps_in = 3
    gaps_out = 5
    border_size = 3
  #  col.active_border=0xff${colorscheme.colors.base07}
  #  col.inactive_border=0xff${colorscheme.colors.base02}
  #  col.group_border_active=0xff${colorscheme.colors.base0B}
  #  col.group_border=0xff${colorscheme.colors.base04}
  }

  decoration {
    rounding=5
  }
  $notifycmd = notify-send -h string:x-canonical-private-synchronous:hypr-cfg -u low

  # █▀ █░█ █▀█ █▀█ ▀█▀ █▀▀ █░█ ▀█▀ █▀
  # ▄█ █▀█ █▄█ █▀▄ ░█░ █▄▄ █▄█ ░█░ ▄█
  bind = SUPER, Return, exec, ${TERMINAL}
  bind = SUPER, b, exec, ${BROWSER}
#  bind = SUPER_SHIFT, f, exec, thunar
  bind = SUPER, a, exec, rofi -show drun -modi drun
#  bind = SUPER, w, exec, makoctl dismiss
''
