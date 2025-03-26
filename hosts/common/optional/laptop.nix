{pkgs, ...}: {
  # Ref:  https://nixos.wiki/wiki/Laptop
  services.thermald.enable = true;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  systemd.services.setChargeThreshold = {
    description = "Set Battery Charge Control Threshold";
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
    startLimitBurst = 0;
    script = ''
      echo 65 > /sys/class/power_supply/BAT0/charge_control_start_threshold
      echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
    };
  };
}
