{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-connections
    gnome.gnome-tweaks
    gnome.seahorse
  ];

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-tour
      gnome-photos
    ])
    ++ (with pkgs.gnome; [
      cheese
      geary
      gnome-calendar
      gnome-contacts
      gnome-clocks
      gnome-maps
      gnome-music
      gnome-weather
      epiphany
      totem
    ]);
}
