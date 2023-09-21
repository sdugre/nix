{inputs, pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;	
  };
  environment.systemPackages = with pkgs; [
    gnome.seahorse
    gnome-connections
  ];

  programs.thunar.enable = true;
}
