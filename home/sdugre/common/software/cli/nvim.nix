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
      '';
    viAlias = true;
    vimAlias = true;
#    plugins = with pkgs.vimPlugins; [
#      # Set theme to nix-colors'.
#      {
#        plugin = vimThemeFromScheme { scheme = colorscheme; };
#        config = ''
#          colorscheme nix-${colorscheme.slug}
#        '';
#      }
#    ];
  };
}
