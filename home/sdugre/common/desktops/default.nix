{ inputs, pkgs, lib, desktop, ... }:
{
  imports = [
    ../software/gui/firefox.nix
    ../software/gui/zathura.nix
    ../font.nix
  ]
  ++ lib.optional (builtins.isString desktop) ./${desktop} 
  ;

  home.packages = with pkgs; [
    backlight      # personal scrtip for adjusting brightness
    galculator     # calculator
    obsidian       # notes
    vlc            # video player
    test-pkg
  ];  
  
  programs.mpv.enable = true;    # video player

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # for obsidian
  ];
}
