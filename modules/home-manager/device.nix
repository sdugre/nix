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
  };
}
