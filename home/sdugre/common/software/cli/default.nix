{
  pkgs,
  config,
  ...
}: {
  imports =
    [
      ./nvim.nix
      ./git.nix
      ./zsh.nix
      ./lf.nix
      ./zellij.nix
    ];

  home.packages = with pkgs; [
    alejandra
    htop
    wget
    curl
    killall
  ];
}
