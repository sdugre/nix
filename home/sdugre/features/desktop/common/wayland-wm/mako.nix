{pkgs, ... }:
{
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
  };

  home.packages = with pkgs; [
    libnotify
  ];
}
