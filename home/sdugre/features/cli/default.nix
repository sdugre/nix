{ pkgs, ... }: {
  imports = [
    ./emacs.nix
    ./git.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    htop
    wget
    curl
  ];  
}
