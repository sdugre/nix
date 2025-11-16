# This file defines overlays
{inputs, ...}: {

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    paperless-ngx = prev.paperless-ngx.overrideAttrs (oldAttrs: {
      doCheck = false;
      disabledTests = (oldAttrs.disabledTests or [ ]) ++ [
        "test_barcodes"
        "test_consume_file"
        "test_management_consumer"
        "test_preprocessor"
        "test_concurrency"
      ];
    });

    # This is for mealie build failure 2025-11-15
    python3Packages = prev.python3Packages.overrideScope (self: super: {
      pint = super.pint.overridePythonAttrs (old: rec {
        version = "0.24.4";
        src = super.fetchPypi {
          pname = "pint";
          version = "0.24.4";
          sha256 = "NSdUObV0g3ps0wIKWkpzZF6xJc5BUqc6LxJr8WS5G4A=";
        };
      });
    });

  };

  stable-packages = final: _prev: {
    stablePkgs = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  pinned-packages = final: _prev: {
    pinned = import inputs.nixpkgs-pinned {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
