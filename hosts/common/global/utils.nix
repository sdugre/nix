{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    autojump
    figurine
    git
    lm_sensors
    nano
    nmap
    nsxiv    
    nvd
    python3
    tmux
    thefuck
    tree
    wl-clipboard # needed for copy/paste in wayland
#    zathura   see home manager package
  ];

}
