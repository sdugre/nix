{
  pkgs, 
  lib,
  config,
  ...
}: lib.mkIf (!config.device.isHeadless) {
  programs.zellij = {
    enable = true;
  };
}
