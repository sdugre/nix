# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {

  # Packages with an actual source
  figurine = pkgs.callPackage ./figurine { };

  # Personal scripts
  backlight = pkgs.callPackage ./backlight { };
  rofi-logout = pkgs.callPackage ./rofi-logout { };
  test-pkg = pkgs.callPackage ./test-pkg { };
}
