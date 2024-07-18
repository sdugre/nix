{ inputs, pkgs, ...}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;	
  };
  environment.systemPackages = with pkgs; [
    nautilus
  ];

  services.udisks2.enable = true; # needed for auto mounting USB drives;  See also Home Manager hyprland config.
}
