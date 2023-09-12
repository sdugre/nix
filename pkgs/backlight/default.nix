# 
{ lib, writeShellApplication }: (writeShellApplication {
  name = "backlight";
  runtimeInputs = [ bc ];

  text = /* bash */ ''
    MAX=24242
    MIN=1000
    set -e
    file="/sys/class/backlight/intel_backlight/brightness"
    current=$(cat "$file")
    new="$current"
    if [ "$2" != "" ]; then
        val=$(echo "$2*$MAX/100" | bc)
    fi
    if [ "$1" = "-inc" ]; then
        new=$(( current + $val ))
    elif [ "$1" = "-dec" ]; then
        new=$(( current - $val ))
    fi
    if [ $new -gt $MAX ]; then
        new=$MAX
    elif [ $new -lt $MIN ]; then
        new=$MIN
    fi
    if [ "$3" != "-q" ]; then
        printf "%.0f%%\n" $(echo "$new/$MAX*100" | bc -l)
    fi
    echo $new > "$file"
  '';
}) // {
  meta = with lib; {
    license = licenses.mit;
    platforms = platforms.all;
  };
}
