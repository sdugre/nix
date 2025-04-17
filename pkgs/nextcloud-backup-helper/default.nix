{ 
  pkgs,
  lib,
  writeShellApplication,
  ...
}:

(writeShellApplication {
  name = "nextcloud-backup-helper";
  runtimeInputs = [ pkgs.rsync ];
  text = 
    /*
    bash
    */
    ''
      set -e
      
      SRC="/mnt/photos/!backup-phone-sean"
      TARGET="/mnt/photos/_ready-for-review"
      mkdir -p "$TARGET"
      rsync -rt --remove-source-files "$SRC"/ "$TARGET"/
      chmod -R a=,a+rX,u+w,g+w "$TARGET" 
      chown -R sdugre:photos "$TARGET"
    '';
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
