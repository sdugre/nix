{ pkgs, ... }:
{
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gnome-photos
  ]) ++ (with pkgs.gnome; [
    cheese
    geary
    gnome-calendar
    gnome-contacts
    gnome-clocks
    gnome-maps
    gnome-music
    gnome-weather
    epiphany
    totem
  ]);
}
