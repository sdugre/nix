# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{pkgs ? (import ../nixpkgs.nix) {}}: {
  # Packages with an actual source
  figurine = pkgs.callPackage ./figurine {};
  tinyMediaManager = pkgs.callPackage ./tinyMediaManager {};
  pia-wg-config = pkgs.callPackage ./pia-wg-config {};

  # Personal scripts
  backlight = pkgs.callPackage ./backlight {};
  nextcloud-backup-helper = pkgs.callPackage ./nextcloud-backup-helper {};
  rofi-logout = pkgs.callPackage ./rofi-logout {};
  rotate-video = pkgs.callPackage ./rotate-video {};
  test-pkg = pkgs.callPackage ./test-pkg {};
  wake = pkgs.callPackage ./wake {};
}
