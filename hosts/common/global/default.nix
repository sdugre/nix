# This file (and the global directory) holds config that i use on all hosts
{ inputs, outputs, config, ... }: {
  imports = [
    ./locale.nix
    ./nix.nix 
    ./tailscale.nix
  ];
}
