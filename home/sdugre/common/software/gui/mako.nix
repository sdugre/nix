{
  pkgs,
  config,
  ...
}: let
  inherit (config.colorscheme) palette kind;
in {
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    #    iconPath =
    #      if kind == "dark" then
    #        "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark"
    #      else
    #        "${config.gtk.iconTheme.package}/share/icons/Papirus-Light";
#    font = "${config.fontProfiles.regular.family} 12";
    padding = "10,20";
    anchor = "top-center";
    width = 400;
    height = 150;
    borderSize = 2;
    backgroundColor = "#${palette.base00}dd";
    borderColor = "#${palette.base03}dd";
    textColor = "#${palette.base05}dd";
    layer = "overlay";
  };

  home.packages = with pkgs; [
    libnotify
  ];
}
