{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "sdugre";
    userEmail = "sdugre@gmail.com";
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };
}
