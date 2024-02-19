# This file defines overlays
{ inputs,... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    gonic = prev.gonic.override {
      buildGoModule = args: prev.buildGoModule (args // rec {
        version = "0.16.2";
        src = final.fetchFromGitHub {
          owner = "sentriz";
          repo = "gonic";
          rev = "v${version}";
          sha256 = "sha256-0KmE1tjWMeudNM3ARK5TZGNzjmC6luqYX/7ESvv7xAY=";
        };
        vendorHash = "sha256-0M1vlTt/4OKjn9Ocub+9HpeRcXt6Wf8aGa/ZqCdHh5M=";
        doCheck = false;
      });
    };

  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
