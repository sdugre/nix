{ lib, buildGoModule, fetchgit }:

# Generates a Wireguard config file for Private Internet Access (PIA) VPN
# Needed for Nixarr
# To make the file, run:  pia-wg-config -o wg0.conf USERNAME PASSWORD

buildGoModule rec {
  pname = "pia-wg-config";
  version = "";

  src = fetchgit {
    url    = "https://github.com/kylegrantlucas/pia-wg-config.git";
    sha256 = "sha256-2mT2wvcxcMvg4JNuFMY5zkHZyzlixr5YzBCszXhzYc4=";
  };

  vendorHash = null;

  doCheck = false;

  meta = with lib; {
    description = "A Wireguard config generator for Private Internet Access.";
    homepage    = "https://github.com/kylegrantlucas/pia-wg-config";
    license     = licenses.mit;
    maintainers = [ maintainers.sdugre ];
  };
}
