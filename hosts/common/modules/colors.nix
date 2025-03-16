{ pkgs, inputs, ...}: 
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
#  stylix.image = ./my-cool-wallpaper.png;
}
