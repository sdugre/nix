{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./mako.nix
#    ./qutebrowser.nix
    ./waybar.nix
    ./rofi.nix
    ./gtk.nix
  ];

  home.packages = with pkgs; [
    swaybg
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };
}
