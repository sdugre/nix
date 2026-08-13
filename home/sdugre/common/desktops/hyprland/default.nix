{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    # wayland stuff necessary for hyprland
    ../../software/gui/gtk.nix
    ../../software/gui/kitty.nix
    ../../software/gui/mako.nix
    ../../software/gui/rofi.nix
    ../../software/gui/hypridle.nix
    ../../software/gui/hyprlock.nix
    ../../software/gui/waybar2.nix
    ../../software/gui/hyprpaper.nix
  ];

  #  xdg.portal.config.common.default = "*";
  services.udiskie.enable = true; # Needed to auto mount USB drives;  See also System default hyprland config.

  home.packages = with pkgs; [
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
    rofi-logout # personal logout script
    swaybg # wallpaper utility
  ] ++ (if !config.device.isLaptop then [
    wayvnc # RDP
  ] else []);

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };

  home.pointerCursor = {
    enable = true;
#    gtk.enable = true;
#    # x11.enable = true;
#    package = pkgs.bibata-cursors;
#    name = "Bibata-Modern-Classic";
#    size = 16;
  };

  gtk = {
    enable = true;
#    theme = {
#      package = pkgs.flat-remix-gtk;
#      name = "Flat-Remix-GTK-Grey-Darkest";
#    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

#    font = {
#      name = "Sans";
#      size = 11;
#    };
  };

  xdg.mimeApps.defaultApplications = {
    "image/png"  = "mpv.desktop";
    "image/jpeg" = "mpv.desktop";
    "image/jpg" = "mpv.desktop";
    "image/webp" = "mpv.desktop";
  };

  wayland.windowManager.hyprland = let

    lua = lib.generators.mkLuaInline;
  
    dsp = {
      exec =            cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
      close =           lua "hl.dsp.window.close()";
      exit =            lua "hl.dsp.exit()";
      float =           lua ''hl.dsp.window.float({ action = "toggle" })'';
      fullscreen =      lua "hl.dsp.window.fullscreen()";
      pseudo =          lua "hl.dsp.window.pseudo()";
      layout =          msg: lua ''hl.dsp.layout("${msg}")'';
      focus =           dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
      swap =            dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';
      toggleSpecial =   name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
      moveToSpecial =   name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
      focusWorkspace =  ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
      moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
      drag =            lua "hl.dsp.window.drag()";
      resize =          lua "hl.dsp.window.resize()";
      sendshortcut =    mod: key: lua ''hl.dsp.send_shortcut({ mods = "${mod}", key = "${key}" })'';
    };

    bind = keys: dispatcher: { _args = [keys dispatcher]; };
    bindOpts = keys: dispatcher: opts: { _args = [keys dispatcher opts]; };
  
    workspaceBinds = lib.concatMap (i:
      let key = toString (lib.mod i 10);
      in [
        (bind "SUPER + ${key}"          (dsp.focusWorkspace i))
        (bind "SUPER + SHIFT + ${key}"  (dsp.moveToWorkspace i))
      ]
    ) (lib.range 1 9);
  
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${config.services.mako.package}/bin/makoctl &
      nm-applet --indicator
      ${pkgs.hypridle}/bin/hypridle
      hyprctl setcursor Bibata-Modern-Classic 24
      blueman-applet
      ${lib.optionalString (!config.device.isLaptop) ''wayvnc -o DP-1 0.0.0.0''}
    '';

  in
  {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    systemd = {
      enable = true;
      # Same as default, but stop graphical-session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };

    extraLuaFiles."cycle-window" = {
      content = ''
        hl.bind("ALT + TAB", function()
          local ws = hl.get_active_workspace()
        
          if ws.tiled_layout == "scrolling" then
            hl.dispatch(hl.dsp.layout("move +col"))
          elseif ws.tiled_layout == "monocle" then
            hl.dispatch(hl.dsp.layout("cyclenext"))
          end  
        end)

        hl.bind("ALT + SHIFT + TAB", function()
          local ws = hl.get_active_workspace()
        
          if ws.tiled_layout == "scrolling" then
            hl.dispatch(hl.dsp.layout("move -col"))
          elseif ws.tiled_layout == "monocle" then
            hl.dispatch(hl.dsp.layout("cycleprev"))
          end
        end)
      '';
      autoLoad = true;
    };

    settings = {
      on = {
        _args = [
          "hyprland.start"
          (lua ''
            function()
              hl.exec_cmd("${startupScript}/bin/start")
            end'')
        ];
      };

      monitor = map (m: 
        { 
          output = "${m.name}"; 
        } // ( if m.enabled then {
          mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = "${m.position}";
          scale = 1;
        } else {
          disabled = true;
        })
      ) (config.monitors);

      config = {
        general = {
          gaps_in = 3;
          gaps_out = 5;
          border_size = 3;
  #       "col.active_border" = "0xff${config.colorscheme.palette.base0C}";
  #       "col.inactive_border" = "0xff${config.colorscheme.palette.base02}";
        };

        input = {
          kb_layout = "us";
          touchpad.disable_while_typing = false;
        	repeat_delay = 350;
        	repeat_rate = 50;
        };

        decoration = {
          active_opacity = 0.94;
          inactive_opacity = 0.75;
          fullscreen_opacity = 1.0;
          rounding = 10;
          blur = {
            enabled = true;
            size = 5;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = true;
          };
          shadow = {
            enabled = true;
            range = 12;
            offset = "3 3";
  #          color = "0x44000000";
  #          color_inactive = "0x66000000";
          };
        };

        cursor.inactive_timeout = 4;
  
        group = {
  #       "col.border_active" = "0xff${config.colorscheme.palette.base0B}";
  #       "col.border_inactive" = "0xff${config.colorscheme.palette.base04}";
          groupbar = {
            font_size = 11;
          };
        };

        ecosystem.no_donation_nag = true;
      };

      bind = let
        makoctl =     "${config.services.mako.package}/bin/makoctl";
        rofi =        "${config.programs.rofi.package}/bin/rofi";
        rofi-logout = "${pkgs.rofi-logout}/bin/rofi-logout";
        grimblast =   "${pkgs.grimblast}/bin/grimblast";
        pactl =       "${pkgs.pulseaudio}/bin/pactl";
        notify-send = "${pkgs.libnotify}/bin/notify-send";
        backlight =   "${pkgs.backlight}/bin/backlight";
        gtk-launch =  "${pkgs.gtk3}/bin/gtk-launch";
        xdg-mime =    "${pkgs.xdg-utils}/bin/xdg-mime";
        defaultApp =  type: "${gtk-launch} $(${xdg-mime} query default ${type})";
        calculator =  "${pkgs.pinned2501.galculator}/bin/galculator";
        terminal =    config.home.sessionVariables.TERMINAL;
        browser =     defaultApp "x-scheme-handler/https";
        editor =      defaultApp "text/plain";
        notepad =     "${pkgs.mousepad}/bin/mousepad";
        hyprlock =    "${config.programs.hyprlock.package}/bin/hyprlock";
      in [
        (bind "SUPER + T"  (dsp.exec "kitty"))
        # Basic binds
        (bind "SUPER + Q"             dsp.close)
        (bind "SUPER + SHIFT + e"     dsp.exit)
        (bind "SUPER + S"             (dsp.layout "togglesplit"))
        (bind "SUPER + F"             dsp.fullscreen)
        (bind "SUPER + SHIFT + SPACE" dsp.float)

        # Program bindings
        (bind "SUPER + RETURN"      (dsp.exec "${terminal}"))
        (bind "SUPER + e"           (dsp.exec "${editor}"))
        (bind "SUPER + v"           (dsp.exec "${editor}"))
        (bind "SUPER + b"           (dsp.exec "${browser}"))
        (bind "SUPER + SPACE"       (dsp.exec "${rofi} -modes \'drun,window,run\' -show drun"))
        (bind "SUPER + d"           (dsp.exec "nautilus &"))
        (bind "SUPER + l"           (dsp.exec "${rofi-logout}"))
        (bind "SUPER + c"           (dsp.exec "${calculator}"))
        (bind "SUPER + n"           (dsp.exec "${notepad}"))

        # Volume
        (bindOpts "XF86AudioMute"         (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") 
          { locked = true; })
        (bindOpts "XF86AudioRaiseVolume"  (dsp.exec "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+") 
          { locked = true; repeating = true; })
        (bindOpts "XF86AudioLowerVolume"  (dsp.exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") 
          { locked = true; repeating = true; })

        (bindOpts "switch:on:Lid Switch"   (dsp.exec "pidof hyprlock || ${hyprlock}") { locked = true; })

        # Brightness
        (bind "XF86MonBrightnessUp"   (dsp.exec "${backlight} -inc 5"))
        (bind "XF86MonBrightnessDown" (dsp.exec "${backlight} -dec 5"))

        # Workspace scroll
        (bind "SUPER + TAB"         (dsp.focusWorkspace "e+1"))
        (bind "SUPER + SHIFT + TAB" (dsp.focusWorkspace "e-1"))
        (bind "SUPER + mouse_down"  (dsp.focusWorkspace "e+1"))
        (bind "SUPER + mouse_up"    (dsp.focusWorkspace "e-1"))
        
        # Scrolling Mode
        # See extraLuaFiles."cycle-window" for more
        (bind "SUPER + H"         (dsp.layout "focus l")) # move focus btw columns & wrap
        (bind "SUPER + L"         (dsp.layout "focus r"))
        (bind "SUPER + SHIFT + H" (dsp.layout "swapcol l")) # swap columns
        (bind "SUPER + SHIFT + L" (dsp.layout "swapcol r"))
        (bind "SUPER + minus"     (dsp.layout "colresize -0.1"))
        (bind "SUPER + equal"     (dsp.layout "colresize +0.1"))

        # Monocle Mode
        # See extraLuaFiles."cycle-window" for more

        # Mouse binds (272=LMB, 273=RMB, 274=MMB)
        (bindOpts "SUPER + mouse:272" dsp.drag { mouse = true; })
        (bindOpts "SUPER + mouse:273" dsp.resize { mouse = true; })
        (bindOpts "SUPER + CTRL_L"    dsp.drag { mouse = true; })
        (bindOpts "SUPER + ALT_L"     dsp.resize { mouse = true; })

        # Screenshots
        (bind "Print"           (dsp.exec "${grimblast} --notify --freeze copy active"))
        (bind "SHIFT + Print"   (dsp.exec "${grimblast} --notify --freeze copy output"))
        (bind "CONTROL + Print" (dsp.exec "${grimblast} --notify --freeze copy screen"))
        (bind "SUPER + Print"   (dsp.exec "${grimblast} --notify --freeze copy area"))
        (bind "ALT + Print"     (dsp.exec "${grimblast} --notify --freeze copy area"))
      ] ++ workspaceBinds;

      window_rule = [
        { match.class = "^(galculator)$"; float = true;
          move = [ "(monitor_w-window_w)-10" "(monitor_h-window_h)-10" ]; }
        { match = {
            class = "^(firefox)$";
            title = "^Extension: \\(Bitwarden Password Manager\\)$";
          }; float = true; }

        { match.class = "^(nm-connection-editor)$"; float = true; }
        { match.class = "^(org.pulseaudio.pavucontrol)$"; float = true; }
      ];

      workspace_rule = ( 
        map (m: { workspace = toString m.workspace; monitor = m.name; }) 
          ( lib.filter (m: m.enabled && m.workspace != null) config.monitors )
      ) ++
      [
        { workspace = "9"; layout = "scrolling"; }
        { workspace = "8"; layout = "monocle"; }
      ];
    };
  };
}
