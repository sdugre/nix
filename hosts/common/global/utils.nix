{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    autojump
    duf
    figurine
    git
    lm_sensors
    nano
    nmap
    nsxiv
    nvd
    python3
    tmux
    tree
    libva-utils
    wl-clipboard # needed for copy/paste in wayland
    #    zathura   see home manager package
  ];
}
