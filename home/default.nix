{ inputs, pkgs, config, hmStateVer, username, hostname, desktop, ... }: 
{
  imports = [ 
    ./sdugre/global
  
  # machine specific configuration
  ./${username}/${hostname}.nix 

  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = hmStateVer;
}
