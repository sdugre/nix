{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./font.nix
    ./vscodium.nix
  ];

  home.packages = with pkgs; [
    obsidian
    vlc
  ];  
}
