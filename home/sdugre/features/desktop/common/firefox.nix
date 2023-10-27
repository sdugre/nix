{ pkgs, lib, inputs, ... }:

let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  imports = [inputs.arkenfox.hmModules.arkenfox];

  programs.firefox = {
    enable = true;
    arkenfox = {
      enable = true;
      version = "118.0";
    };
    profiles.default = {
      id = 0;
      arkenfox = {
        enable = true;
	"0000".enable = true;
	"0100".enable = true; # Startup
	"0200".enable = true; # Geolocation
	"0300".enable = true; # Quieter Fox
	"0600".enable = true; # Block Implicit Outbound
	"0700".enable = true; # DNS
	"0800".enable = true; # Location Bar
	"0900".enable = true; # Passwords
	"1000".enable = true; # Disk Avoidance
      };

      isDefault = true;
      extensions = with addons; [
        bitwarden
        libredirect
        ublock-origin
        bypass-paywalls-clean
        istilldontcareaboutcookies
      ];

      search = {
        default = "DuckDuckGo";
        force = true;
	engines = {
          "NixOS Packages" = {
            urls = [{template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";}];
            icon = ''${pkgs.fetchurl {
              url = "https://nixos.org/favicon.png";
              sha256 = "sha256-awcsDbbpRcDJnJpRavj/IcKMReEektRcqKbE35IJTKQ=";
            }}'';
            definedAliases = ["@nixpkgs" "@np"];
          };
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
