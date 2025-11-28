# First:
# make keys, copy from here:  https://api.wordpress.org/secret-key/1.1/salt/
# sudo mkdir -p /var/lib/wordpress/[domain]/
# sudo tee /var/lib/wordpress/[domain]/secret-keys.php > /dev/null << 'EOF'
# <?php
# // ... paste all 8 lines from the key generator
# ?>
# EOF
#
# sudo chmod 644 /var/lib/wordpress/[domain]/secret-keys.php
# download wordpress: 
# wget https://wordpress.org/latest.tar.gz
# tar xvf latest.tar.gz -C /var/lib/wordpress/[domain]/
# rm latest.tar.gz

{ config, lib, pkgs, ... }:

let
  domain = "seandugre.com";

  # Auxiliary functions
  fetchPackage = { name, version, hash, isTheme }:
    pkgs.stdenv.mkDerivation rec {
      inherit name version hash;
      src = let type = if isTheme then "theme" else "plugin";
      in pkgs.fetchzip {
        inherit name version hash;
        url = "https://downloads.wordpress.org/${type}/${name}.${version}.zip";
      };
      installPhase = "mkdir -p $out; cp -R * $out/";
    };

  fetchPlugin = { name, version, hash }:
    (fetchPackage {
      name = name;
      version = version;
      hash = hash;
      isTheme = false;
    });

  fetchTheme = { name, version, hash }:
    (fetchPackage {
      name = name;
      version = version;
      hash = hash;
      isTheme = true;
    });

  # Plugins
  google-site-kit = (fetchPlugin {
    name = "google-site-kit";
    version = "1.103.0";
    hash = "sha256-8QZ4XTCKVdIVtbTV7Ka4HVMiUGkBYkxsw8ctWDV8gxs=";
  });

  # Themes
  astra = (fetchTheme {
    name = "astra";
    version = "4.1.5";
    hash = "sha256-X3Jv2kn0FCCOPgrID0ZU8CuSjm/Ia/d+om/ShP5IBgA=";
  });

in {
  services = {
    nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;
    };

    wordpress = {
      webserver = "nginx";
      sites."${domain}" = {
        plugins = { inherit google-site-kit; };
        themes = { inherit astra; };
        settings = { WP_DEFAULT_THEME = "astra"; };
        database.createLocally = true;
      };
    };
  };

  environment.persistence."/persist".directories =
    [ "/var/lib/mysql" "/var/lib/wordpress" ];
}

