{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    autojump
    lm_sensors
    nano
    nmap
    nsxiv    
    python3
    tmux
    thefuck
    tree
    wl-clipboard # needed for copy/paste in wayland
    zathura
  ];

}
