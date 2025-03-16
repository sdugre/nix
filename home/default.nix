{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  hmStateVer,
  username,
  hostname,
  desktop,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) colorschemeFromPicture nixWallpaperFromScheme;
in {
  imports =
    [
      # modules
      inputs.nur.modules.homeManager.default
      inputs.nix-colors.homeManagerModule

      inputs.sops-nix.homeManagerModules.sops

      # global default cli tools
      ./${username}/common/software/cli

      # machine specific configuration
      ./${username}/${hostname}.nix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules)
    ++ lib.optional (builtins.isString desktop) ./${username}/common/desktops
    # default desktop config
    ;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = username;
    stateVersion = hmStateVer;
    homeDirectory = "/home/${username}";
    sessionPath = ["/home/${username}/.local/bin"];
    sessionVariables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      BROWSER = "firefox";
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  colorscheme = lib.mkDefault colorSchemes.dracula;

  sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
}
