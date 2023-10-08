{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.kicad
    pkgs.fritzing
    pkgs.ngspice
  ];
}
