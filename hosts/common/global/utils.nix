{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    autojump
    duf
    figurine
    git
    libva-utils
    lm_sensors
    nano
    nmap
    nsxiv
    nvd
    python3
    tmux
    tree
    vim
    wl-clipboard # needed for copy/paste in wayland
    #    zathura   see home manager package
  ];
}
