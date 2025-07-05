# Shell for bootstrapping flake-enabled nix and home-manager
# You can enter it through 'nix develop' or (legacy) 'nix-shell'
{pkgs ? (import ./nixpkgs.nix) {}}:

let
  mkdocsEnv = pkgs.python3.withPackages (ps: [
    ps.mkdocs
    ps.mkdocs-material
  ]);
in
{
  default = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [nix home-manager git];
  };

  mkdocs = pkgs.mkShell {
    nativeBuildInputs = [ mkdocsEnv ];
  };
}
