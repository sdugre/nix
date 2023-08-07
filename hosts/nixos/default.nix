# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ../common/global
    ./hardware-configuration.nix

    ./config/gnome.nix

  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

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
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
  };

  # FIXME: Add the rest of your current configuration
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = ([
    inputs.agenix.packages.x86_64-linux.default
  ]) ++ (with pkgs; [
    gnome.gnome-tweaks
    gnome.seahorse
    lm_sensors
    mnamer
    nmap
    tmux
    tree
    wireshark
 
  ]);

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };



  # TODO: Set your hostname
  networking.hostName = "nixos";
  
  networking.firewall.allowedTCPPorts = [ 3389 ]; 

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 10;

  programs.zsh.enable = true;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    sdugre = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      description = "Sean Dugre";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    permitRootLogin = "yes";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    passwordAuthentication = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  fileSystems."/mnt/video" = {
    device = "192.168.1.16:/volume1/video";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  };
  fileSystems."/mnt/music" = {
    device = "192.168.1.16:/volume1/music";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 
  fileSystems."/mnt/photo" = {
    device = "192.168.1.16:/volume1/photo";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 
  fileSystems."/mnt/downloads" = {
    device = "192.168.1.16:/volume1/downloads";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  };
  fileSystems."/mnt/homes" = {
    device = "192.168.1.16:/volume1/homes";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 
  fileSystems."/mnt/docs" = {
    device = "192.168.1.16:/volume1/docs";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 

}
