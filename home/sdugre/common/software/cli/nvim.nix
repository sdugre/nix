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
      '';
    viAlias = true;
    vimAlias = true;
  };
}
