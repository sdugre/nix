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

      # Delete empty month and year directories only if not current
      now_year=$(date +%Y)
      now_month=$(date +%m)
  
      # Delete empty month directories of previous months/years
      find "$SRC" -mindepth 2 -maxdepth 2 -type d -empty | while read -r monthdir; do
        year=$(basename "$(dirname "$monthdir")")
        month=$(basename "$monthdir")
        if (( 10#$year < 10#$now_year || (10#$year == 10#$now_year && 10#$month < 10#$now_month) )); then
          rmdir "$monthdir"
        fi
      done
  
      # Delete empty year directories from previous years
      find "$SRC" -mindepth 1 -maxdepth 1 -type d -empty | while read -r yeardir; do
        year=$(basename "$yeardir")
        if [[ "$year" -lt "$now_year" ]]; then
          rmdir "$yeardir"
        fi
      done

      chmod -R a=,a+rX,u+w,g+w "$TARGET" "$TARGET_VID" 
      chown -R sdugre:photos "$TARGET" 
      chown -R sdugre:media "$TARGET_VID"
    '';
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
