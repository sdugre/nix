{
  pkgs,
  lib,
  ...
}: {
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:appmenu";
      num-workspaces = 2;
    };
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 900;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout = 1800;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/drool-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/drool-d.svg";
      primary-color = "#86b6ef";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = ["<Super>d"];
      www = ["<Super>b"];
      volume-up = ["F10"];
      volume-down = ["F9"];
      volume-mute = ["F8"];
      next = ["F2"];
      previous = ["F1"];
      screen-brightness-up = ["F7"];
      screen-brightness-down = ["F6"];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Launch Terminal";
      command = "kgx";
      binding = "<Super>Return";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Launch Browser";
      command = "firefox";
      binding = "<Super>b";
    };
  };
}
