{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;
#    gtk4.theme = config.gtk.theme;
    cursorTheme = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
    };
  };
}
