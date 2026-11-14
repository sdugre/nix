{ pkgs, ... }:

{
  vim = {
    viAlias = false;
    vimAlias = false;

    globals.mapleader = " ";

    options = {
      clipboard = "unnamedplus";
      number = true;
      relativenumber = true;
      scrolloff = 10;

      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      autoindent = true;
    };

    languages.nix = {
      enable = true;
      treesitter.enable = true;
      lsp.enable = true;

      format = {
        enable = true;
        type = "nixfmt";
      };
    };

    treesitter.enable = true;

    lsp = {
      enable = true;
      formatOnSave = true;
    };

    autocomplete.blink-cmp.enable = true;

    extraPlugins.oscyank = {
      package = pkgs.vimPlugins.vim-oscyank;
      setup = ''
        vim.cmd([[
          vmap <C-c> y:OSCYankVisual<CR>
        ]])
      '';
    };
  };
}
