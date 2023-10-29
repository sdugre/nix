{ inputs, ... }: {
  imports = [ 
    ./global
    
    ./features/desktop/gnome
    
    ./features/desktop/common/optional/vscodium.nix
  ];
}
