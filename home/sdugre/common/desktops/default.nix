{
  inputs,
  pkgs,
  lib,
  desktop,
  ...
}: {
  imports =
    [
      ../software/gui/firefox.nix
      ../software/gui/zathura.nix
      ../font.nix
    ]
    ++ lib.optional (builtins.isString desktop) ./${desktop};

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
    "application/pdf" = ["org.pwmt.zathura.desktop"];
  };
  xdg.mimeApps.associations.removed = {
    "application/pdf" = ["chromium-browser.desktop"];
  };
  home.packages = with pkgs; [
    backlight # personal scrtip for adjusting brightness
    galculator # calculator
    obsidian # notes
    vlc # video player
    test-pkg
  ];

  programs.mpv.enable = true; # video player
  programs.chromium.enable = true; # for testing, esphome, etc.

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # for obsidian
  ];
}
