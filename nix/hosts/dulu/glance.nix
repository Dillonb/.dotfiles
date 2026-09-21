{ config, pkgs, ... }:
let
  localUrl = name: "http://127.0.0.1:${toString config.dgbCustom.ports.${name}}";
in
{
  sops.secrets."glance_secret_key" = {
    sopsFile = ../../secrets/dulu.yaml;
  };
  sops.secrets."glance_password_hash" = {
    sopsFile = ../../secrets/dulu.yaml;
  };
  sops.secrets."plex-token".restartUnits = [ "glance.service" ];
  sops.secrets."jellyfin-api-key" = {
    sopsFile = ../../secrets/dulu.yaml;
  };
  sops.templates."glance-env" = {
    content = ''
      GLANCE_SECRET_KEY=${config.sops.placeholder."glance_secret_key"}
      GLANCE_PASSWORD_HASH=${config.sops.placeholder."glance_password_hash"}
      JELLYFIN_API_KEY=${config.sops.placeholder."jellyfin-api-key"}
    '';
    restartUnits = [ "glance.service" ];
  };

  services.glance = {
    enable = true;
    package = pkgs.unstable.glance;
    openFirewall = false;
    environmentFile = config.sops.templates."glance-env".path;
    settings = {
      server = {
        host = "127.0.0.1";
        port = config.dgbCustom.ports.glance;
        proxied = true;
      };
      auth = {
        secret-key = "\${GLANCE_SECRET_KEY}";
        users.dgb.password-hash = "\${GLANCE_PASSWORD_HASH}";
      };
      theme = {
        background-color = "230 24 19";
        primary-color = "221 89 72";
        positive-color = "89 51 61";
        negative-color = "349 89 72";
      };
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "calendar";
                  first-day-of-week = "monday";
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      title = "Media management";
                      links = [
                        {
                          title = "Ombi";
                          url = "https://plex-requests.dgb.sh";
                        }
                        {
                          title = "Sonarr";
                          url = "https://s.cyphe.red";
                        }
                        {
                          title = "Radarr";
                          url = "https://r.cyphe.red";
                        }
                        {
                          title = "SABnzbd";
                          url = "https://sab.cyphe.red";
                        }
                        {
                          title = "Transmission";
                          url = "https://t.cyphe.red";
                        }
                        {
                          title = "Tautulli";
                          url = "https://tt.cyphe.red";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "split-column";
                  widgets = [
                    {
                      type = "custom-api";
                      title = "Plex - Now playing";
                      title-url = "https://dulu.dgb.sh/web";
                      cache = "15s";
                      url = "${localUrl "plex"}/status/sessions";
                      headers = {
                        Accept = "application/json";
                        X-Plex-Token._secret = config.sops.secrets."plex-token".path;
                      };
                      template = builtins.readFile ./glance/plex.html;
                    }
                    {
                      type = "custom-api";
                      title = "Jellyfin - Now playing";
                      title-url = "https://jellyfin.dgb.sh";
                      cache = "15s";
                      url = "${localUrl "jellyfin"}/Sessions";
                      headers = {
                        Accept = "application/json";
                        Authorization = "MediaBrowser Token=\"\${JELLYFIN_API_KEY}\"";
                      };
                      template = builtins.readFile ./glance/jellyfin.html;
                    }
                  ];
                }
                {
                  type = "monitor";
                  title = "Services";
                  cache = "1m";
                  sites = [
                    {
                      title = "Plex";
                      url = "https://dulu.dgb.sh/web";
                      check-url = "${localUrl "plex"}/identity";
                    }
                    {
                      title = "Jellyfin";
                      url = "https://jellyfin.dgb.sh";
                      check-url = "${localUrl "jellyfin"}/health";
                    }
                    {
                      title = "Audiobookshelf";
                      url = "https://books.dgb.sh";
                      check-url = "${localUrl "audiobookshelf"}/healthcheck";
                    }
                    {
                      title = "copyparty";
                      url = "https://files.dgb.sh";
                      check-url = "${localUrl "copyparty"}/";
                    }
                    {
                      title = "Miniflux";
                      url = "https://miniflux.dgb.sh";
                      check-url = "${localUrl "miniflux"}/healthcheck";
                    }
                    {
                      title = "Home Assistant";
                      url = "https://home.dgb.sh";
                      check-url = "${localUrl "homeAssistant"}/";
                    }
                  ];
                }
                {
                  type = "hacker-news";
                  limit = 15;
                  collapse-after = 5;
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
