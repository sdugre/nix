{ config, desktop, lib, pkgs, ... }: {

  # Define a user account.
  users.mutableUsers = false;
  users.users.sdugre = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
    hashedPassword = "$6$VFLMhcigCBrLJ3PF$I7jBNN15btQBG48dd.s987gZKYjkx2Ku796TmMSKV4bhn7p/sEF9F7E0MygJTCpfKuAEfcdxBeJ7ZFz0c/OxG0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP08ryfgQQWLbhbNYqwEBTKCBIArQPalcjtRo54mpr/v sdugre@gmail.com" # thinkpad
    ];
  };
}

