{
  pkgs,
  config,
  nix-config-path,
  ...
}: {
  # for this to work, need to download icons using:
  # nix run nixpkgs#wget https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example  
  xdg.configFile."lf/icons".source = ./icons.example;

  programs.lf = {
    enable = true;
    commands = {
      dragon-out = ''%${pkgs.dragon-drop}/bin/dragon-drop -a -x "$fx"'';
      editor-open = ''$$EDITOR $f'';
      mkdir = ''
        ''${{
          printf "Directory Name: "
          read DIR
          mkdir $DIR
        }}
      '';
      delete = ''
        ''${{
          clear
          tput cup $(($(tput lines)/3))
          tput bold
          set -f
          printf "%s\n\t" "$fx"
          printf "delete?[y/N]"
          read ans
          [ $ans = "y" ] && rm -rf -- $fx
        }}
      '';    
      fzf_jump = ''
        ''${{
          res="$(find . | ${pkgs.fzf}/bin/fzf --reverse --header='Jump to location')"
          if [ -n "$res" ]; then
            if [ -d "$res" ]; then
              cmd="cd"
            else
              cmd="select"
            fi
            res="$(printf '%s' "$res" | sed 's/\\/\\\\/g;s/"/\\"/g')"
            lf -remote "send $id $cmd \"$res\""
          fi
        }}
      '';

      moveto = ''
        ''${{
          set -f
          directories=("$HOME/Documents" "$HOME/Downloads" "$HOME/Pictures" "$HOME/Videos" "Specify directory")
          dest=$(printf '%s\n' "''${directories[@]}" | ${pkgs.fzf}/bin/fzf --prompt 'Move to where? ')
          if [ "$dest" = "Specify directory" ]; then
            dest=$(read -p "Enter custom directory: " && echo "$REPLY" | sed "s|~|$HOME|")
          fi
          [ -z "$dest" ] && exit
          clear; tput cup $(($(tput lines)/3)); tput bold
          echo "From:"
          echo "$fx" | sed 's/^/   /'
          printf "To:\n   %s\n\n\tmove?[y/N]" "$dest"
          read -r ans
          [ "$ans" != "y" ] && exit
          for x in $fx; do
            mv -iv "$x" "$dest"
          done &&
          ${pkgs.libnotify}/bin/notify-send "🚚 File(s) moved." "File(s) moved to $dest."
        }}
      '';    
    };

    
    keybindings = {
      "\\\"" = "";
      o = "";
      c = "mkdir";
      "." = "set hidden!";
      "`" = "mark-load";
      "\\'" = "mark-load";
      "<enter>" = "open";
      D = "delete";
      do = "dragon-out";
      M = ":moveto";

      "g~" = "cd";
      gh = "cd ~";
      "g/" = "cd /";
      "gn" = "cd ${nix-config-path}";
      gd = "cd ~/Documents";
      gD = "cd ~/Downloads";

      ee = "editor-open";
      V = ''$${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';
      "<c-f>" = ":fzf_jump";
    };

    settings = {
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    extraConfig = let
      previewer = pkgs.writeShellScriptBin "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5

        # if its an image, use kitty's icat feature to display the image in the terminal
        if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
            exit 1
        fi

        # Check if it's a PDF file
        if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" == "application/pdf" ]]; then
          # Convert the first page of the PDF to a PNG image using pdftoppm
          tmp_image="/tmp/preview"
          ${pkgs.poppler-utils}/bin/pdftoppm -png -r 72 -f 1 -l 1 "$file" "$tmp_image" && \
          ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "''${tmp_image}-1.png" < /dev/null > /dev/tty
          exit 1
        fi

        ${pkgs.pistol}/bin/pistol "$file"
      '';
      # clears any displayed images
      cleaner = pkgs.writeShellScriptBin "clean.sh" ''
        ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
      '';
    in ''
      set cleaner ${cleaner}/bin/clean.sh
      set previewer ${previewer}/bin/pv.sh
      set ifs "\n"
      set scrolloff 10
      set period 1
      set hiddenfiles ".*:*.log:*.run.xml"
      set autoquit true
    '';
  };
}
