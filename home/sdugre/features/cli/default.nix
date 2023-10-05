{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    htop
    wget
    curl
    killall
  ];  
}
