{ inputs, pkgs, nix-colors, ... }: 
let 
  nix-colors-lib = nix-colors.lib.contrib {inherit pkgs; };
in 
{
  imports = [ 
    ./global
#    ./features/desktop/gnome
    ./features/desktop/hyprland
  ];

  wallpaper = "~/Documents/nix-config/home/sdugre/wallpapers/landscape-morning.jpg";
  #colorscheme = inputs.nix-colors.colorSchemes.dracula;
  colorscheme = nix-colors-lib.colorSchemeFromPicture {
    path = ./wallpapers/landscape-morning.jpg;
    kind = "light";
  };
}
