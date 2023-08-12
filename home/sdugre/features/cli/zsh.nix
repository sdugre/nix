{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = { }; # all defaults are OK.
    enableAutosuggestions = true;
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [ 
      "git" 
      "sudo"
      "thefuck" 
    ];
    theme = "agnoster";
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    menslo-lgs-nf
  ];
}
