{...}: {
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;
  services.avahi.settings.publish."disable-publishing" = false;
  services.avahi.settings.publish.disable-user-service-publishing = false;
  services.avahi.settings.publish.publish-addresses = true;
}
