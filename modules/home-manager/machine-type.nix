{lib, ...}: let
  inherit (lib) types mkOption;
in {
  options.machine-type = mkOption {
    type = types.str;
    default = "";
    description = ''
      Machine Type (i.e laptop, workstation)
    '';
  };
}
