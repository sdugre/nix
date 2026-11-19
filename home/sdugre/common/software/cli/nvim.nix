{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nvf.homeModules.default
  ];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        withRuby = false;
        withPython3 = true;
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
            type = [ "nixfmt" ];
          };
        };

        treesitter.enable = true;
        telescope.enable = true;
        binds.whichKey.enable = true;
        git.gitsigns.enable = true;

        lsp = {
          enable = true;
          formatOnSave = true;
        };

        autocomplete.blink-cmp = {
          enable = true;
          setupOpts = {
            keymap = {
              preset = "default";
              "<C-n>" = [
                "select_next"
                "fallback"
              ];
              "<C-p>" = [
                "select_prev"
                "fallback"
              ];
            };
            completion.documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
              update_delay_ms = 50;
            };
          };
        };

        extraPlugins.oscyank = {
          package = pkgs.vimPlugins.vim-oscyank;
          setup = ''
            vim.cmd([[
              vmap <C-c> y:OSCYankVisual<CR>
            ]])
          '';
        };
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
