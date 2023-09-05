{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./font.nix
  ];

  home.packages = with pkgs; [
    obsidian
    vlc
  ];  

}
