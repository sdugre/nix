{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kicad
    # fritzing  # build error 2025-04-25;  Wait until i actually need it.
    ngspice
  ];
}
