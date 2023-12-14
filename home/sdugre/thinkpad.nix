{ inputs, pkgs, config, nix-colors, ... }: 
{
  imports = [ 
    ./global

#    ./features/desktop/gnome
    ./features/desktop/hyprland

    ./features/desktop/common/optional/vscodium.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  wallpaper = "~/Documents/nix-config/home/sdugre/wallpapers/landscape-morning.jpg";
  colorscheme = inputs.nix-colors.colorSchemes.atlas;
}
