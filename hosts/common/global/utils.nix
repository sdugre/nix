{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    autojump
    lm_sensors
    nano
    nmap
    python3
    tmux
    thefuck
    tree
    zathura
  ];

}
