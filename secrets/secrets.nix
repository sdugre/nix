let
  sdugre = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICULJMDBFEGTcSJsE+b3/YNNRWJbsqGllOTYSf8Plpwr";
  users = [ sdugre ];

  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0/eaIuu+J/6ZQJgvrd01Ao1TO6wRx0Vz91ImvlO4TX";
  systems = [ system ];

in
  {
    "git.age".publicKeys = [ sdugre system ];
    # "secret2.age".publicKeys = users ++ systems;
  }
