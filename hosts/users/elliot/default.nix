{ config, desktop, lib, pkgs, ... }: 
let ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{

  # Define a user account.
  users.users.elliot = {
    isNormalUser = true;
    extraGroups = [ 
    ] ++ ifTheyExist [
      "video"
    ];
    packages = with pkgs; [ 
      firefox
    ];
    shell = pkgs.zsh;
#    hashedPassword = "$6$XYIoiA7EZYTFRKQb$oQ4EK2tgW0VLhc3juDxgL8tYdnJwFf34PmWTFkwLTuPIzYlJSqYAqDdQImTKJKb5e.s8yB.DarUpd8AC.62HW0";
    hashedPassword = "$6$v.U9dU5MUebe3WiU$JtwY.fOQ6cExs/lIpo1nb/TK28QT2cAHe5Q5WGljZ47HcnoZdI4AJcfOUsNvyAaeQf0uB5yW/QRwGignTqSVu1";
    openssh.authorizedKeys.keys = [
 #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP08ryfgQQWLbhbNYqwEBTKCBIArQPalcjtRo54mpr/v sdugre@gmail.com" # thinkpad
    ];
  };

  security.pam.services.swaylock = { };
}

