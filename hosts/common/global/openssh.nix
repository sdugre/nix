{...}: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  users.users."sdugre".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClGhadzTeReeyj+ia/vKriprFP23SwTzth8Cpj9/0emSKJipOiihy812wQOaFvToS1wwfNkNyd8m2E9VAfoZW42FUrF0ppzTlneuJAvvIR0l2cb/x8zsjo2Kc9EwL4sdB+0Td3jrcmnJHW0bNKPLAcDBXlIgYgel3P8pfBWMXrXREF1bJNKezhpeWl6+iERpHZht4aXYcveog/izzQ/2UINis/z+s2BELNmbAfm4Edpf/UBz7UdTtHI6p0g5x977YOKgm2QeNSknHValUC28FVtgnPFj1zhgzvrUF4BUH6anw1Vt5QQbPovoUXx3s4iGPioWPQlQzVRZfkCk8Doda9"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4aT1FF3ZhpBOETEXae8KKJlNfl5h1A+q0c2x3K5Cq+" # optiplex
    # content of authorized_keys file
    # note: ssh-copy-id will add user@your-machine after the public key
    # but we can remove the "@your-machine" part
  ];
}
