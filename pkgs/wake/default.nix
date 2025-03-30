{
  lib,
  stdenv,
  wol,
  writeShellScriptBin,
}:
(writeShellApplication {
  name = "wake";
  runtimeInputs = [wol];
  text =
    /*
    bash
    */
    ''
      #!/usr/bin/env bash

      # Table of hostnames and MAC addresses
      declare -A host_mac_table=(
          ["optiplex"]="00:11:22:33:44:55"
      )

      # Function to resolve hostname to IP address
      resolve_hostname() {
          getent hosts "$1" | awk '{ print $1 }'
      }

      # Check if hostname is provided
      if [ $# -eq 0 ]; then
          echo "Usage: $0 <HOSTNAME>"
          exit 1
      fi

      hostname="$1"

      # Check if the hostname exists in the table
      if [[ -v host_mac_table[$hostname] ]]; then
          mac_address="''${host_mac_table[$hostname]}"
          echo "Waking up $hostname (MAC: $mac_address)"
          ${wol}/bin/wol "$mac_address"

          # Resolve hostname to IP address
          ip_address=$(resolve_hostname "$hostname")

          if [ -n "$ip_address" ]; then
              echo "Waiting for $hostname to wake up..."
              for i in {1..30}; do
                  if ping -c 1 -W 1 "$ip_address" &> /dev/null; then
                      echo "$hostname is now online at $ip_address"
                      exit 0
                  fi
                  sleep 2
              done
              echo "Timeout: $hostname did not respond within 60 seconds"
          else
              echo "Could not resolve IP address for $hostname"
          fi
      else
          echo "Error: Hostname '$hostname' not found in the table"
          echo "Available hostnames:"
          printf '%s\n' "''${!host_mac_table[@]}" | sort
          exit 1
      fi
    '';
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
