{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    autojump
    lm_sensors
    nmap
    tmux
    thefuck
    tree
  ];

}
