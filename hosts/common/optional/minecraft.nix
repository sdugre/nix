{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.minecraft
  ];
}
