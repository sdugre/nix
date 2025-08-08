{
  inputs,
  pkgs,
  config,
  ...
}: let
  wallpaperPath = "~/Documents/nix-config/home/sdugre/wallpapers/gruvbox/abstract.jpg";
in {
  imports = [
    # Optional machine specific packages
    ./common/software/gui/vscodium.nix
    ./common/software/cli/feh.nix
    inputs.stylix.homeModules.stylix
  ];
  device.isLaptop = true;
  device.cpuThermalZone = 7;
  wallpaper = wallpaperPath;
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  #  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atlas.yaml";
  #  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  stylix.polarity = "dark";
  stylix.targets.vscode.profileNames = ["Default"];
  stylix.targets.firefox.profileNames = ["default"];
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Classic";
  stylix.cursor.size = 20;

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
