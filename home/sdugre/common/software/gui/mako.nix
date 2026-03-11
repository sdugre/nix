{
  pkgs,
  config,
  ...
}: let
#  inherit (config.colorscheme) palette kind;
in {
  services.mako = {
    enable = true;
    settings = {
      default-timeout = "5000";
      #    iconPath =
      #      if kind == "dark" then
      #        "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark"
      #      else
      #        "${config.gtk.iconTheme.package}/share/icons/Papirus-Light";
  #    font = "${config.fontProfiles.regular.family} 12";
      outer-margin = "10";
      padding = "10,20";
      anchor = "top-right";
      width = "400";
      height = "150";
      border-size = "3";
      border-radius = "10";
  #    backgroundColor = "#${palette.base00}dd";
  #    borderColor = "#${palette.base03}dd";
  #    textColor = "#${palette.base05}dd";
      layer = "overlay";
    };
  };

  home.packages = with pkgs; [
    libnotify
  ];
}
