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
      dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
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
          res="$(find . -maxdepth 1 | ${pkgs.fzf}/bin/fzf --reverse --header='Jump to location')"
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

      "g~" = "cd";
      gh = "cd ~";
      "g/" = "cd /";
      "gn" = "cd ${nix-config-path}";

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
