{
  inputs,
  lib,
  config,
  ...
}: let
  isEd25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age.sshKeyPaths = map getKeyPath keys;
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = ["/var/lib/sops-nix"];
  };

}
