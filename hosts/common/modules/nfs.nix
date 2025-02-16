{
  config,
  lib,
  ...
}: {
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /svr/nfs                   100.0.0.0/8(insecure,rw,no_subtree_check,crossmnt,fsid=0)
    /svr/nfs/paperless-import  100.0.0.0/8(insecure,rw,no_subtree_check)
    /svr/nfs/media             100.0.0.0/8(insecure,rw,no_subtree_check,all_squash,anonuid=1001,anongid=986)
    /svr/nfs/files             100.0.0.0/8(insecure,rw,no_subtree_check)
    /svr/nfs/photos            100.0.0.0/8(insecure,rw,no_subtree_check)
    /svr/nfs/music             192.168.1.32(insecure,no_subtree_check) # volumio
  '';
    # fixed rpc.statd port; for firewall
  services.nfs.server.lockdPort = 4001;
  services.nfs.server.mountdPort = 4002;
  services.nfs.server.statdPort = 4000;

  fileSystems."/svr/nfs/paperless-import" = {
    device = "/var/lib/paperless/consume";
    options = ["bind"];
  };

  fileSystems."/svr/nfs/media" = {
    device = "/mnt/data/media";
    options = ["bind"];
  };

  fileSystems."/svr/nfs/files" = {
    device = "/mnt/data/files";
    options = ["bind"];
  };

  fileSystems."/svr/nfs/music" = {
    device = "/mnt/data/media/music";
    options = ["bind"];
  };

  fileSystems."/svr/nfs/photos" = {
    device = "/mnt/data/photos";
    options = ["bind"];
  };

  networking.firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
  networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
}
