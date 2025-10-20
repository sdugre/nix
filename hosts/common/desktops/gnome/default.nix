{pkgs, ...}: {
  imports = [
    # Modules
    ../../optional/pipewire.nix
    ../../modules/printing.nix
  ];

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnome-connections
    gnome-tweaks
    seahorse
    gnomeExtensions.tiling-assistant
    cheese
    geary
  ];

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-clocks
      gnome-music
      gnome-weather
      gnome-maps
      gnome-contacts
      gnome-tour
      gnome-photos
      gnome-calendar
      epiphany
      totem
    ])
    ++ (with pkgs.gnome; [
    ]);
}
