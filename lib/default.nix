{ self, inputs, outputs, ... }: {

  # Helper function for generating host configs
  # Credit: https://git.sysctl.io/albert/nix/src/branch/main/lib/default.nix
  mkHost = {
    hostname,
    username   ? "sdugre",
    desktop    ? null,
    gpu        ? null,
    platform   ? "x86_64-linux",
    theme      ? "default",
    type       ? "default",
    stateVer   ? "23.11"
  }: inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs outputs desktop hostname username gpu platform theme; };
    modules = [
      # 'default', 'small, or 'minimal'
      ../hosts/${type}.nix
    ];
  };
}
