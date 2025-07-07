{ 
  pkgs,
  lib,
  writeShellApplication,
  ...
}:

(writeShellApplication {
  name = "nextcloud-backup-helper";
  runtimeInputs = [ pkgs.rsync pkgs.findutils ];
  text = 
    /*
    bash
    */
    ''
      set -e
      
      SRC="/mnt/photos/!backup-phone-sean"
      TARGET="/mnt/photos/_ready-for-review"
      TARGET_VID="/mnt/photos/_ready-for-review/vid"

      mkdir -p "$TARGET"
      mkdir -p "$TARGET_VID"

      # Move video files to VIDEO_DIR
      find "$SRC" -type f \( \
        -iname '*.mp4' -o -iname '*.mov' \
        -o -iname '*.mpeg' -o -iname '*.mpg' \
        \) -exec mv -v {} "$TARGET_VID" \;

      rsync -rt --remove-source-files \
        --exclude='*.mp4' --exclude='*.mov' \
        --exclude='*.mpeg' --exclude='*.mpg' \
        "$SRC"/ "$TARGET"/

      # Delete empty directories from SRC
      find "$SRC" -mindepth 1 -type d -empty -delete

      chmod -R a=,a+rX,u+w,g+w "$TARGET" "$TARGET_VID" 
      chown -R sdugre:photos "$TARGET" "$TARGET_VID"
    '';
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
