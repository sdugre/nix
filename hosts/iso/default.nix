{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nixos-hardware,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages =
    [
    ]
    ++ (with pkgs; [
    ]);

  nix.settings = {
    extra-substituters = [ "http://bin-cache" ];
    extra-trusted-public-keys = [ "bin-cache:O7CCOIP4nu44qHdDzUuf1cEDSiCe0ArU8EM3QDJSLPY=" ];
  };
}
