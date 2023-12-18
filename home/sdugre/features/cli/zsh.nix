{ pkgs, ... }:
let
  p10kTheme = ./p10k.zsh;
in
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = { }; # all defaults are OK.
    enableAutosuggestions = true;
    initExtra = ''
      [[ ! -f ${p10kTheme} ]] || source ${p10kTheme}
    '';
    loginExtra = ''
    '';

#      if [ "$(tty)" = "/dev/tty1" ]; then
#        exec Hyprland
#      fi


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
      "thefuck"
      "autojump" 
    ];
    theme = "agnoster";
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  }; 
}
