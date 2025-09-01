{
  pkgs,
  lib,
  inputs,
  ...
}: let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in {
  imports = [inputs.betterfox.homeModules.betterfox];

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      Preferences = {
        # use bitwarden for this
        "signon.rememberSignons" = false;
      };
      ExtensionSettings = {
        # Disable built-in search engines
        "amazondotcom@search.mozilla.org".installation_mode = "blocked";
        "bing@search.mozilla.org".installation_mode = "blocked";
        "ebay@search.mozilla.org".installation_mode = "blocked";
        "google@search.mozilla.org".installation_mode = "blocked";
      };
    };
    betterfox.enable = true;
    betterfox.profiles.default.enableAllSections = true;

    profiles.default = {
      id = 0;
      isDefault = true;
      extensions.packages = with addons; [
        bitwarden
        libredirect
        linkding-extension
        linkding-injector
        ublock-origin
        #        bypass-paywalls-clean
        istilldontcareaboutcookies
        vimium-c
      ];

      search = {
        default = "SearX";
        force = true;
        engines = {
          "NixOS Packages" = {
            urls = [{template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";}];
            icon = ''${pkgs.fetchurl {
                url = "https://nixos.org/favicon.png";
                sha256 = "sha256-17/8nOSLmkDyABW9LdHhTqPykqYDtCFuqFeGTT4sqLo=";
                #              sha256 = "sha256-awcsDbbpRcDJnJpRavj/IcKMReEektRcqKbE35IJTKQ=";
              }}'';
            definedAliases = ["@nixpkgs" "@np"];
          };

          "youtube" = {
            urls = [{template = "https://yewtu.be/search?q={searchTerms}";}];
            icon = ''${pkgs.fetchurl {
                url = "https://www.youtube.com/s/desktop/280a3f09/img/favicon.ico";
                sha256 = "sha256-i7HQ+kOhdDbVndVG9vdMdtxEc13vdSLCLYAxFm24kR0=";
              }}'';
            definedAliases = ["@youtube" "@yt"];
          };

          "Github Nix" = {
            urls = [{template = "https://github.com/search?q=lang%3Anix+{searchTerms}&type=code";}];
            # icon = ''${pkgs.fetchurl {
            #url = "https://www.youtube.com/s/desktop/280a3f09/img/favicon.ico";
            #sha256 = "sha256-i7HQ+kOhdDbVndVG9vdMdtxEc13vdSLCLYAxFm24kR0=";
            #}}'';
            definedAliases = ["@ghn"];
          };

          "Perplexity" = {
            urls = [{template = "https://www.perplexity.ai/?q={searchTerms}";}];
            icon = "https://www.perplexity.ai/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = ["@pp"];
          };

          "SearX" = {
            urls = [{template = "https://search.seandugre.com/?q={searchTerms}";}];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@sx"];
          };
          # Hide all other search engines
          amazondotcom-us.metaData.hidden = true;
          google.metaData.hidden = true;
          bing.metaData.hidden = true;
          ebay.metaData.hidden = true;
          wikipedia.metaData.hidden = true;
        };
      };

      settings = {
        # enable HTTPS-Only Mode
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        # Privacy Settings
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;
        # Disable all sorts of telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        # As well as Firefox 'experiments'
        "experiments.activeExperiment" = false;
        "experiments.enabled" = false;
        "experiments.supported" = false;
        "network.allow-experiments" = false;
        # Disable Pocket Integration
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "extensions.pocket.enabled" = false;
        "extensions.pocket.api" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.showHome" = false;
        "extensions.pocket.site" = "";
        # Other
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
      };
    };
  };
}
