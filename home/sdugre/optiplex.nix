{
  inputs,
  pkgs,
  config,
  nix-colors,
  ...
}: 
  let 
#    wallpaperPath = "./wallpapers/landscape-morning.jpg";
    wallpaperPath = "~/Documents/nix-conf/home/sdugre/wallpapers/mountain.jpeg";

  in {
  imports = [
    # Optional machine specific packages
    ./common/software/gui/vscodium.nix
    inputs.stylix.homeModules.stylix

  ];

  device.cpuThermalZone = 2;
  wallpaper = wallpaperPath;
  stylix.enable = true;
#  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
#  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atlas.yaml";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  stylix.polarity = "dark";
  stylix.targets.vscode.profileNames = [ "Default" ];
  stylix.targets.firefox.profileNames = [ "default" ];
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Classic";
  stylix.cursor.size = 20;

  #  ------   -----   ------
  # | DP-3 | | DP-1| | DP-2 |
  #  ------   -----   ------
  monitors = [
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      workspace = "1";
      primary = true;
    }
    {
      name = "DP-2";
      width = 1920;
      height = 1080;
      position = "auto-right";
      workspace = "2";
    }
  ];
}
