# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{
  pkgs ? (import ../nixpkgs.nix) {},
  nvf,
}: {
  # Packages with an actual source
  figurine = pkgs.callPackage ./figurine {};
  mailclean = pkgs.callPackage ./mailclean {};
  nvf-test = pkgs.callPackage ./nvf-test { inherit nvf; };
  pia-wg-config = pkgs.callPackage ./pia-wg-config {};
  #tinyMediaManager = pkgs.callPackage ./tinyMediaManager {};

  # Personal scripts
  backlight = pkgs.callPackage ./backlight {};
  nextcloud-backup-helper = pkgs.callPackage ./nextcloud-backup-helper {};
  rofi-logout = pkgs.callPackage ./rofi-logout {};
  rotate-video = pkgs.callPackage ./rotate-video {};
  test-pkg = pkgs.callPackage ./test-pkg {};
  wake = pkgs.callPackage ./wake {};
}
