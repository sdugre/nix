# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  fonts = import ./fonts.nix;
  wallpaper = import ./wallpaper.nix;
}
