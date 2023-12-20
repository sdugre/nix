{
  description = "Sean's nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";   

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Agenix Age-encrypted secrets for NixOS
    agenix.url = "github:ryantm/agenix";

    # Nix User Repository (NUR)
    nur.url = "github:nix-community/NUR";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";   

    nix-colors.url = "github:misterio77/nix-colors";
  
    arkenfox.url = "git+https://github.com/dwarfmaster/arkenfox-nixos?ref=main";
    arkenfox.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, agenix, nur, hyprland, nix-colors, nixos-hardware, arkenfox, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      libx = import ./lib { inherit self inputs outputs; };  
    in
    rec {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      wallpapers = import ./home/sdugre/wallpapers;

      # Primary Laptop
      nixosConfigurations = {
        thinkpad = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/thinkpad
            agenix.nixosModules.default
            nur.nixosModules.nur
            nixos-hardware.nixosModules.lenovo-thinkpad-t490
          ];
        };
      };

      nixosConfigurations = {
        chummie    = libx.mkHost { hostname = "chummie";                                           };  # server
	nixos      = libx.mkHost { hostname = "nixos";      desktop = "gnome"; stateVer = "23.05"; }; # test VM
        chromebook = libx.mkHost { hostname = "chromebook"; desktop = "gnome"; stateVer = "23.05"; }; # secondary laptop
      };

      homeConfigurations = {
        "sdugre@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/sdugre/nixos.nix
            nur.nixosModules.nur  
          ];
        };
        "sdugre@thinkpad" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/sdugre/thinkpad.nix
          ];
        };
        "sdugre@chromebook" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/sdugre/chromebook.nix
          ];
        };
        "sdugre@chummie" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/sdugre/chummie.nix
          ];
        };
      };
    };
}
