{
  config,
  lib,
  ...
}: {
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /svr/nfs                   100.0.0.0/8(insecure,rw,no_subtree_check,crossmnt,fsid=0)
    /svr/nfs/paperless-import  100.0.0.0/8(insecure,rw,no_subtree_check)
    /svr/nfs/media             100.0.0.0/8(insecure,rw,no_subtree_check,all_squash,anonuid=1001,anongid=986,crossmnt)
    /svr/nfs/files             100.0.0.0/8(insecure,rw,no_subtree_check)
    /svr/nfs/photos            100.0.0.0/8(insecure,rw,no_subtree_check)
    /svr/nfs/docs              100.0.0.0/8(insecure,rw,no_subtree_check)
    /svr/nfs/music             192.168.1.32(insecure,no_subtree_check) # volumio
  '';
    # fixed rpc.statd port; for firewall
  services.nfs.server.lockdPort = 4001;
  services.nfs.server.mountdPort = 4002;
  services.nfs.server.statdPort = 4000;

  fileSystems."/svr/nfs/paperless-import" = {
    device = "/var/lib/paperless/consume";
    fsType = "nfs";
    options = ["bind"];
  };

  fileSystems."/svr/nfs/media" = {
    device = "/mnt/data/media";
    fsType = "nfs";
    options = [
      "bind"
      "x-systemd.requires-mounts-for=/mnt/data/media"
    ];
  };

  fileSystems."/svr/nfs/media/books" = {
    device = "/mnt/data/media/books";
    fsType = "nfs";
    options = [
      "bind"
    ];
  };

  fileSystems."/svr/nfs/media/movies" = {
    device = "/mnt/data/media/movies";
    fsType = "nfs";
    options = [
      "bind"
    ];
  };

  fileSystems."/svr/nfs/media/movies/movies" = {
    device = "/mnt/data/media/movies/movies";
    fsType = "nfs";
    options = [
      "bind"
    ];
  };

  fileSystems."/svr/nfs/media/movies/ski-movies" = {
    device = "/mnt/data/media/movies/ski-movies";
    fsType = "nfs";
    options = [
      "bind"
    ];
  };

  fileSystems."/svr/nfs/media/music" = {
    device = "/mnt/data/media/music";
    fsType = "nfs";
    options = [
      "bind"
    ];
  };

  fileSystems."/svr/nfs/media/tv" = {
    device = "/mnt/data/media/tv";
    fsType = "nfs";
    options = [
      "bind"
    ];
  };

  fileSystems."/svr/nfs/media/videos" = {
    device = "/mnt/data/media/videos";
    fsType = "nfs";
    options = [
      "bind"
    ];
  };

  fileSystems."/svr/nfs/media/videos/home-videos" = {
    device = "/mnt/data/media/videos/home-videos";
    fsType = "nfs";
    options = [
      "bind"
    ];
  };

  fileSystems."/svr/nfs/files" = {
    device = "/mnt/data/files";
    fsType = "nfs";
    options = ["bind"];
  };

  fileSystems."/svr/nfs/music" = {
    device = "/mnt/data/media/music";
    fsType = "nfs";
    options = ["bind"];
  };

  fileSystems."/svr/nfs/photos" = {
    device = "/mnt/photos";
    fsType = "nfs";
    options = ["bind"];
  };

  fileSystems."/svr/nfs/docs" = {
    device = "/mnt/docs";
    fsType = "nfs";
    options = ["bind"];
  };
  networking.firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
  networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
}
