{
  config,
  pkgs,
  ...
}: {
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set selection-clipboard clipboard
      set page-padding 3
      map <C-p> print
      map d scroll half-down
      map u scroll half-up
      map F toggle_fullscreen
      map <C-=> zoom in
      map <C--> zoom out
      map [fullscreen] <C-p> print
      map [fullscreen] d scroll half-down
      map [fullscreen] u scroll half-up
      map [fullscreen] F toggle_fullscreen
      map [fullscreen] <C-=> zoom in
      map [fullscreen] <C--> zoom out
    '';
  };
}
