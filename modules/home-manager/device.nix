{lib, ...}: let
  inherit (lib) types mkOption;
in {
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
  };
}
