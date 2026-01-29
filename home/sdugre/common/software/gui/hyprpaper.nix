{
  config,
  lib,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "${config.wallpaper}";
          fit_mode = "cover";
        }
      ];
    };
  };
}

