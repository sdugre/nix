{
  config,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "run,drun,window";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = false;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
  };
}
