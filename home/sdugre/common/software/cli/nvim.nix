{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    extraConfig = /* vim */ ''
      set clipboard=unnamedplus
      '';
    viAlias = true;
    vimAlias = true;
  };
}
