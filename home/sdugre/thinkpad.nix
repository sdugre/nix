{ inputs, pkgs, config, nix-colors, ... }: 
{
  imports = [ 

    # Optional Packages
    ./features/desktop/common/optional/vscodium.nix
  ];

  wallpaper = "~/Documents/nix-config/home/sdugre/wallpapers/landscape-morning.jpg";
  colorscheme = inputs.nix-colors.colorSchemes.atlas;
}
