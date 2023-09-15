# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  backlight = pkgs.callPackage ./backlight { };
  logout = pkgs.callPackage ./logout { };
}
