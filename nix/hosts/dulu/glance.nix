{ config, ... }:
let
  localUrl = name: "http://127.0.0.1:${toString config.dgbCustom.ports.${name}}";
in
{
  sops.secrets."glance-env" = {
    sopsFile = ../../secrets/glance.yaml;
    key = "environment";
    restartUnits = [ "glance.service" ];
  };

  services.glance = {
    enable = true;
    openFirewall = false;
    environmentFile = config.sops.secrets."glance-env".path;
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
