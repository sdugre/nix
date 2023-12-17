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
  
  programs.mpv.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # for obsidian
  ];
}
