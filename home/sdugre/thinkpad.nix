{ inputs, pkgs, config, nix-colors, ... }: 
{
  imports = [ 
    ./global
#    ./features/desktop/gnome
    ./features/desktop/hyprland
  ];

  wallpaper = "~/Documents/nix-config/home/sdugre/wallpapers/landscape-morning.jpg";
  colorscheme = inputs.nix-colors.colorSchemes.atlas;
}
