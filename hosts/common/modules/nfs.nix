{ config, lib,... }:{

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /svr/nfs                   100.0.0.0/8(insecure,rw,no_subtree_check,crossmnt,fsid=0)
    /svr/nfs/paperless-import  100.0.0.0/8(insecure,rw,no_subtree_check)
    /svr/nfs/media             100.0.0.0/8(insecure,rw,no_subtree_check)
  '';

  fileSystems."/svr/nfs/paperless-import" = {
    device = "/var/lib/paperless/consume";
    options = [ "bind" ];
  };

  fileSystems."/svr/nfs/media" = {
    device = "/mnt/data/media";
    options = [ "bind" ];
  };

}
