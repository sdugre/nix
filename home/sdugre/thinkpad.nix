{ inputs, pkgs, config, nix-colors, ... }: 
{
  imports = [ 
    ./global

#    ./features/desktop/gnome
    ./features/desktop/hyprland

    # Optional Packages
    ./features/desktop/common/optional/vscodium.nix
    ./features/desktop/common/optional/tinyMediaManager.nix
  ];

  wallpaper = "~/Documents/nix-config/home/sdugre/wallpapers/landscape-morning.jpg";
  colorscheme = inputs.nix-colors.colorSchemes.atlas;
}
