{ inputs, ... }: {
  imports = [ 
    ./global
    ./features/desktop/gnome
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

}
