{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = { }; # all defaults are OK.
    enableAutosuggestions = true;
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [ "git" "sudo" ];
    theme = "agnoster";
  };
}
