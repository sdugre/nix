{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./common/software/cli/beets.nix
  ];
  device.isHeadless = true;
}
