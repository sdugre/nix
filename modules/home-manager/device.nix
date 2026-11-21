{ lib, config, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.device = {
    isLaptop = mkOption {
      type = lib.types.bool;
      default = false;
    };

    isHeadless = mkOption {
      type = lib.types.bool;
      default = false;
    };

    cpuThermalZone = mkOption {
      type = lib.types.int;
      description = "The zone number in /sys/class/thermal/thermal_zone* representing x86_pkg_temp";
      default = 0;
    };

    trackpad = mkOption {
      description = "Per-device trackpad settings for Hyprland.";
      default = { };

      type = types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            default = "";
            description = "The trackpad device name reported by hyprctl devices.";
          };

          sensitivity = mkOption {
            type = types.addCheck types.number (value: value >= -1 && value <= 1);
            default = 0.3;
            description = "Pointer sensitivity, from -1 to 1.";
          };

          accelProfile = mkOption {
            type = types.enum [
              "adaptive"
              "flat"
            ];
            default = "adaptive";
            description = "Pointer acceleration profile.";
          };
        };
      };
    };
  };

  config.assertions = [
    {
      assertion =
        (config.device.isLaptop && config.wayland.windowManager.hyprland.enable)
        -> (config.device.trackpad.name != "");
      message = ''
        device.trackpad.name must be set for this host.
        Run `hyprctl devices` to find the trackpad device name.
      '';
    }
  ];
}
