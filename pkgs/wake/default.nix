{
  lib,
  stdenv,
  wol,
  net-tools,
  writeShellApplication,
}:
(writeShellApplication {
  name = "wake";
  runtimeInputs = [wol net-tools];
  text =
    /*
    bash
    */
    ''
      #!/usr/bin/env bash
      
      declare -A host_mac_table=(
          ["optiplex"]="D8:9E:F3:77:1C:0F"
      )
      
      if [ $# -eq 0 ]; then
          echo "Usage: $0 <HOSTNAME>"
          exit 1
      fi
      
      hostname="$1"
      
      if [[ -v host_mac_table[$hostname] ]]; then
          mac_address="''${host_mac_table[$hostname]}"
          echo "Waking up $hostname (MAC: $mac_address)"
          wol "$mac_address"
          
          echo "Waiting for $hostname to wake up..."
          for _ in {1..30}; do
              if ping -c 1 "$hostname" >/dev/null 2>&1; then
                  ip_address=$(arp -n | grep -i "$mac_address" | awk '{print $1}')
                  if [ -n "$ip_address" ]; then
                      echo "$hostname is now online at $ip_address"
                      exit 0
                  else
                      echo "$hostname responded to ping but IP could not be found in ARP table"
                      exit 1             
                  fi
              fi
              sleep 2
          done
          echo "Timeout: $hostname did not respond within 60 seconds"
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
