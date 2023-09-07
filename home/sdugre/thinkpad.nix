{ inputs, ... }: {
  imports = [ 
    ./global
#    ./features/desktop/gnome
    ./features/desktop/hyprland
  ];

  wallpaper = "~/Documents/nix-config/home/sdugre/wallpapers/landscape-morning.jpg";
}
