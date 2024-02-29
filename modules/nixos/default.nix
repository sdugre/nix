# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  # List your module files here
  persistence = import ./persistence.nix;
  tailscale-autoconnect = import ./tailscale-autoconnect.nix;
#  stirling-pdf = import ./stirling-pdf.nix;
}
