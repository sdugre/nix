{pkgs, ...}: {
  imports = [
    ./nvim.nix
    ./git.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    alejandra
    htop
    wget
    curl
    killall
  ];

  #  home.file = {
  #    nanorc = {
  #      text = "include /run/current-system/sw/share/nano/";
  #      target = ".config/nano/.nanorc";
  #    };
  #  };
}
