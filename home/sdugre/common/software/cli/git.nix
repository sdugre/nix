{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "sdugre";
      user.email = "sdugre@gmail.com";
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
    };
  };
}
