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
    gonic = prev.gonic.override {
      buildGoModule = args:
        prev.buildGoModule (args
          // rec {
            version = "0.16.4";
            src = final.fetchFromGitHub {
              owner = "sentriz";
              repo = "gonic";
              rev = "v${version}";
              #          sha256 = "sha256-nLONZ0iz27Za09bv8gt0BpBAC4kSn+mh941cRDk1kBU=";
              sha256 = "sha256-+8rKODoADU2k1quKvbijjs/6S/hpkegHhG7Si0LSE0k=";
            };
            vendorHash = "sha256-6JkaiaAgtXYAZqVSRZJFObZvhEsHsbPaO9pwmKqIhYI=";
            doCheck = false;
          });
    };
    
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
    
    # This for mealie build failure 2025-06-24
    python313 = prev.python313.override {
      packageOverrides = self: super: {
        lxml-html-clean = super.lxml-html-clean.overridePythonAttrs (old: {
          # Disable tests to bypass failures
          doCheck = false;
        });
      };
    };

  };

  stable-packages = final: _prev: {
    stablePkgs = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
