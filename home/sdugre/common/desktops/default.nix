{ pkgs, lib, desktop, ... }:
{
  imports = [
    ../software/gui/firefox.nix
    ../software/gui/zathura.nix
    ../font.nix
  ]
  ++ lib.optional (builtins.isString desktop) ./${desktop} 
  ;

  home.packages = with pkgs; [
    obsidian
    vlc
  ];  
  
  programs.mpv.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # for obsidian
  ];
}
