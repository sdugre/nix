{
  pkgs, 
  ...
}: 

{
  home.packages = [
    pkgs.feh
  ];

  home.shellAliases = {
    fehk = ''
      feh -F --edit \
        --action1 "mv '%f' /mnt/photos/\!work/" \
        --action2 "mv '%f' /mnt/photos/\!house/" \
        .
    '';
    # Used to process photos,
    # Run command in folder you want to process
    # Press 1 to move work photos
    # Press 2 to move house photos
    # Press <Ctrl> + Del to delete a photo
    # Press < or > to rotate a photo
    # Press q to quit
  };
}
