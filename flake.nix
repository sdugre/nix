{
  description = "Sean's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #    hyprland.url = "github:hyprwm/hyprland";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    arkenfox.url = "git+https://github.com/dwarfmaster/arkenfox-nixos?ref=main";
    arkenfox.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nixarr.url = "github:rasmus-kirk/nixarr";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur,
    hyprland,
    nix-colors,
    nixos-hardware,
    arkenfox,
    nixarr,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];
    libx = import ./lib {inherit self inputs outputs;};
  in rec {
    inherit lib;
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );
    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    wallpapers = import ./home/sdugre/wallpapers;

    nixosConfigurations = {
      chummie = libx.mkHost {hostname = "chummie";}; # server
      nixos = libx.mkHost {
        hostname = "nixos";
        desktop = "gnome";
        stateVer = "23.05";
      }; # test VM
      chromebook = libx.mkHost {
        hostname = "chromebook";
        desktop = "cinnamon";
        stateVer = "23.11";
      }; # secondary laptop
      thinkpad = libx.mkHost {
        hostname = "thinkpad";
        desktop = "hyprland";
      }; # primary laptop
    };

    homeConfigurations = {
      "sdugre@chummie" = libx.mkHome {hostname = "chummie";};
      "sdugre@chromebook" = libx.mkHome {
        hostname = "chromebook";
        desktop = "cinnamon";
        hmStateVer = "23.11";
      };
      "sdugre@nixos" = libx.mkHome {
        hostname = "nixos";
        desktop = "gnome";
        hmStateVer = "23.05";
      };
      "sdugre@thinkpad" = libx.mkHome {
        hostname = "thinkpad";
        desktop = "hyprland";
	nix-config-path = "~/Documents/nix-config";
      };
    };
  };
}
