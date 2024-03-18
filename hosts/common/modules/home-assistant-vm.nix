{ pkgs, config, ... }:
{
  virtualisation = {
    libvirtd = {
      enable = true;
      # Used for UEFI boot of Home Assistant OS guest image
      qemu.ovmf.enable = true;
    };
  };

  programs.virt-manager.enable = true;

  networking.bridges.br0.interfaces = ["eno2"];
  networking.interfaces.br0 = {
    useDHCP = false;
    ipv4.addresses = [{
      "address" = "192.168.1.201";
      "prefixLength" = 24;
    }];
  };

}
