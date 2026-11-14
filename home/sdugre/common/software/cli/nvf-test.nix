{
  pkgs, 
  ...
}: 

{
  home.packages = [
    pkgs.nvf-test
  ];
}
