{
  inputs,
  pkgs,
  config,
  nix-colors,
  ...
}: 
  let 
    wallpaperPath = "~/Documents/nix-config/home/sdugre/wallpapers/landscape-morning.jpg";
  in {
  imports = [
    # Optional machine specific packages
    ./common/software/gui/vscodium.nix
  ];

  wallpaper = wallpaperPath;
  colorscheme = inputs.nix-colors.colorSchemes.atlas;
}
