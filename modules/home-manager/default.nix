# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  device = import ./device.nix;
  fonts = import ./fonts.nix;
  monitors = import ./monitors.nix;
  wallpaper = import ./wallpaper.nix;
}
