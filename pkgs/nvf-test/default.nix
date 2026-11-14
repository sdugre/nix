{ 
  pkgs, 
  nvf, 
  writeShellScriptBin 
}:

let
  editor = (nvf.lib.neovimConfiguration {
    inherit pkgs;

    modules = [
      ./config.nix
    ];
  }).neovim;
in
writeShellScriptBin "nvim-test" ''
  export NVIM_APPNAME=nvf-test
  exec ${editor}/bin/nvim "$@"
''
