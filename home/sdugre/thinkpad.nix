{
  inputs,
  pkgs,
  config,
  nix-colors,
  ...
}: 
  let 
    wallpaperPath = "~/Documents/nix-config/home/sdugre/wallpapers/gruvbox/abstract.jpg";
  in {
  imports = [
    # Optional machine specific packages
    ./common/software/gui/vscodium.nix
    inputs.stylix.homeManagerModules.stylix
  ];

  wallpaper = wallpaperPath;
  colorscheme = inputs.nix-colors.colorSchemes.atlas;
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
#  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atlas.yaml";
#  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  stylix.image = ./landscape-morning.jpg;
  stylix.targets.hyprlock.enable = false;
  stylix.targets.mako.enable = false;
  stylix.polarity = "dark";
  stylix.targets.vscode.profileNames = [ "Default" ];
  stylix.targets.firefox.profileNames = [ "default" ];

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
   #   workspace = "1";
      primary = true;
    }
  ];
}
