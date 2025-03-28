{
  config,
  pkgs,
  inputs,
  ...
}: 

# Required to use vimThemeFromScheme to set colorscheme.
 # with inputs.nix-colors.lib-contrib { inherit pkgs; };
{
  programs.neovim = {
    enable = true;

    extraConfig =
      /*
      vim
      */
      ''
        set clipboard=unnamedplus
	      set number relativenumber
        set scrolloff=10
        set expandtab
        set tabstop=2
        set shiftwidth=2
        set softtabstop=2
        set autoindent

        vmap <C-c> y:OSCYankVisual<cr>
      '';
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-oscyank # allows copy to local clipboard from remote nvim session
 #     { # Set theme to nix-colors'.
 #       plugin = vimThemeFromScheme { scheme = config.colorscheme; };
 #       config = ''
 #         colorscheme nix-${config.colorscheme.slug}
 #       '';
 #     }
    ];
  };
}
