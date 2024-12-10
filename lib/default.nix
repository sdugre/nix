{
  self,
  inputs,
  outputs,
  ...
}: {
  # Helper function for generating host configs
  # Credit: https://git.sysctl.io/albert/nix/src/branch/main/lib/default.nix
  mkHost = {
    hostname,
    username ? "sdugre",
    desktop ? null,
    gpu ? null,
    platform ? "x86_64-linux",
    theme ? "default",
    type ? "default",
    stateVer ? "23.11",
  }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs desktop hostname username gpu platform theme stateVer;};
      modules = [
        # 'default', 'small, or 'minimal'
        ../hosts/${type}.nix
        inputs.nur.modules.nixos.default
      ];
    };

  mkHome = {
    hostname,
    username ? "sdugre",
    desktop ? null,
    platform ? "x86_64-linux",
    theme ? "default",
    type ? "default",
    hmStateVer ? "23.11",
    nix-config-path ? "~/nix-config", # used in lf config, does not actually set the path
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {inherit inputs outputs desktop hostname platform username theme hmStateVer nix-config-path;};
      modules = [
        ../home/${type}.nix
      ];
    };
}
