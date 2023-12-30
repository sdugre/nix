{ inputs, pkgs, config, nix-colors, ... }: 
{
  imports = [ 

    # Optional machine specific packages
    ./common/software/gui/vscodium.nix
  ];

  wallpaper = "~/Documents/nix-config/home/sdugre/wallpapers/landscape-morning.jpg";
  colorscheme = inputs.nix-colors.colorSchemes.atlas;
}
