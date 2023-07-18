{ pkgs, ... }:
{
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    epiphany
    cheese
    geary
    gnome-contacts
  ]);
}
