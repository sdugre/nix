{
  config,
  pkgs,
  ...
}: {
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
  };
}
