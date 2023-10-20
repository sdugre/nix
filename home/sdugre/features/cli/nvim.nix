{ config, pkgs, ... }:

  programs.neovim = {
    enable = true;

    extraConfig = /* vim */ ''
      "Use system clipboard
      set clipboard=unnamedplus
      '';

  };