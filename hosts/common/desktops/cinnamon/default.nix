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
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
  };

  environment.systemPackages = with pkgs; [
  ];

  environment.cinnamon.excludePackages = (with pkgs; [
  ]);
}
