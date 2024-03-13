{
    gonic = prev.gonic.override {
      buildGoModule = args: prev.buildGoModule (args // rec {
        version = "0.16.3";
        src = final.fetchFromGitHub {
          owner = "sentriz";
          repo = "gonic";
          rev = "v${version}";
          sha256 = "sha256-0KmE1tjWMeudNM3ARK5TZGNzjmC6luqYX/7ESvv7xAY=";
        };
        vendorHash = "sha256-0M1vlTt/4OKjn9Ocub+9HpeRcXt6Wf8aGa/ZqCdHh5M=";
        doCheck = false;
      });
    };
}
