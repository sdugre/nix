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
      '';
    viAlias = true;
    vimAlias = true;
  };
}
