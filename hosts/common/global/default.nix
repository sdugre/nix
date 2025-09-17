# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  config,
  ...
}: {
  imports =
    [
      ./fonts.nix
      ./locale.nix
      ./nix.nix
      #    ./tailscale.nix # replace with tailscale-autoconnect.nix module
      ./sops.nix
      ./systemd-initrd.nix
      ./utils.nix
      ./openssh.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.pinned-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur =
          (import (builtins.fetchTarball {
            url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
            sha256 = "061rwh8clvzbk3hvibgrwnpxx4aami1j8bsdz76zp8kb4m8alr7g";
          })) {
            inherit pkgs;
          };
      };

      #      packageOverrides = pkgs: {
      #        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      #          inherit pkgs;
      #        };
      #      };
    };
  };

  programs.zsh.enable = true;
}
