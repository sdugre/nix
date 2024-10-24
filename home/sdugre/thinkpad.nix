{ inputs, pkgs, config, nix-colors, ... }: 
{
  imports = [ 

    # Optional machine specific packages
    ./common/software/gui/vscodium.nix
#    ./common/software/gui/calibre.nix
  ];

  programs.chromium.enable = true;  # for testing, esphome, etc.

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };

  wallpaper = "~/Documents/nix-config/home/sdugre/wallpapers/landscape-morning.jpg";
  colorscheme = inputs.nix-colors.colorSchemes.atlas;
}
