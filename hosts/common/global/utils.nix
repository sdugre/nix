{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    autojump
    lm_sensors
    nano
    nmap
    tmux
    thefuck
    tree
  ];

}
