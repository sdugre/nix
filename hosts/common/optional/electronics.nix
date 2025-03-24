{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kicad
    fritzing
    ngspice
  ];
}
