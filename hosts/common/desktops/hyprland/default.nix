{ inputs, pkgs, ...}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;	
  };
  environment.systemPackages = with pkgs; [
#    gnome.seahorse
#    gnome-connections
    gnome.nautilus
  ];

#  services.gvfs.enable = true;

#  xdg.portal = {
#    enable = true;
#    wlr.enable = true;
#    config.common.default = "*";
#  };

  # Configure keymap in X11
#  services.xserver = {
#    layout = "us";
#    xkbVariant = "";
#  };

}
