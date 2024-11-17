{pkgs, ...}: {
  environment.systemPackages = [
    #    pkgs.kicad  temp disable  -failing update due to wxpython
    pkgs.fritzing
    pkgs.ngspice
  ];
}
