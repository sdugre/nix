{
  pkgs,
  lib,
  config,
  inputs,
  desktop,
  ...
}: let
  p10kTheme = ./p10k.zsh;
  inherit (lib) mkIf;
  #  hyprlandInstalled = config.programs.hyprland.enable == true;
  hyprlandInstalled = desktop == "hyprland";
  #  hyprlandInstalled = false; # temp turn off until I can figure out how to pass in variables
in {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {}; # all defaults are OK.
    autosuggestion.enable = true;
    initContent = ''
      [[ ! -f ${p10kTheme} ]] || source ${p10kTheme}
    '';
    loginExtra = mkIf hyprlandInstalled ''
      #      if [ "$(tty)" = "/dev/tty1" ]; then
      #        exec Hyprland
      #      fi
    '';

    profileExtra = ''
      echo ""
      ${pkgs.figurine}/bin/figurine -f "3d.flf" $(hostname)
      echo ""
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "sudo"
      "autojump"
    ];
    theme = "agnoster";
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };
}
