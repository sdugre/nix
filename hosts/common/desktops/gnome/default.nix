{ pkgs, ... }: {
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
    gnome.gnome-tweaks
    gnome.seahorse
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gnome-photos
  ]) ++ (with pkgs.gnome; [
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
