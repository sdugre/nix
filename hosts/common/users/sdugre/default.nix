{ pkgs, config, ... }:
let ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users = {
    sdugre = {
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      description = "Sean Dugre";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ 
        "networkmanager" 
        "wheel" 
      ] ++ ifTheyExist [
        "video"
        "libvirtd" 
      ];
    };
  };

  security.pam.services.swaylock = {};
}
