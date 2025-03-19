{ config, ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/html/dgb.sh";
      };

      "dgb.gay" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/html/dgb.gay";
      };

      "picrite.dgb.gay" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/html/picrite.dgb.gay";
      };

      "kanin.dgb.gay" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/html/dgb.gay/kanin";
      };

      "dulu.dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        # http2 can more performant for streaming: https://blog.cloudflare.com/introducing-http2/
        http2 = true;
        # from https://nixos.wiki/wiki/Plex
        extraConfig = ''
          #Some players don't reopen a socket and playback stops totally instead of resuming after an extended pause
          send_timeout 100m;

          # Why this is important: https://blog.cloudflare.com/ocsp-stapling-how-cloudflare-just-made-ssl-30/
          ssl_stapling on;
          ssl_stapling_verify on;

          ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
          ssl_prefer_server_ciphers on;
          #Intentionally not hardened for security for player support and encryption video streams has a lot of overhead with something like AES-256-GCM-SHA384.
          ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';

          # Forward real ip and host to Plex
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $server_addr;
          proxy_set_header Referer $server_addr;
          # Wiki said to enable this, but this breaks CORS, so commented out
          # proxy_set_header Origin $server_addr;

          # Plex has A LOT of javascript, xml and html. This helps a lot, but if it causes playback issues with devices turn it off.
          gzip on;
          gzip_vary on;
          gzip_min_length 1000;
          gzip_proxied any;
          gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
          gzip_disable "MSIE [1-6]\.";

          # Nginx default client_max_body_size is 1MB, which breaks Camera Upload feature from the phones.
          # Increasing the limit fixes the issue. Anyhow, if 4K videos are expected to be uploaded, the size might need to be increased even more
          client_max_body_size 100M;

          # Plex headers
          proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
          proxy_set_header X-Plex-Device $http_x_plex_device;
          proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
          proxy_set_header X-Plex-Platform $http_x_plex_platform;
          proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
          proxy_set_header X-Plex-Product $http_x_plex_product;
          proxy_set_header X-Plex-Token $http_x_plex_token;
          proxy_set_header X-Plex-Version $http_x_plex_version;
          proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
          proxy_set_header X-Plex-Provides $http_x_plex_provides;
          proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
          proxy_set_header X-Plex-Model $http_x_plex_model;

          # Websockets
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";

          # Buffering off send to the client as soon as the data is received from Plex.
          proxy_redirect off;
          proxy_buffering off;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:32400/";
        };
      };

      "plex-requests.dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          client_max_body_size 10m;
          client_body_buffer_size 128k;

          # Timeout if the real server is dead
          proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

          # Advanced Proxy Config
          send_timeout 5m;
          proxy_read_timeout 240;
          proxy_send_timeout 240;
          proxy_connect_timeout 240;

          # Basic Proxy Config
          proxy_set_header Host $host:$server_port;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-Host $server_name;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto https;
          proxy_redirect  http://  $scheme://;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_cache_bypass $cookie_session;
          proxy_no_cache $cookie_session;
          proxy_buffers 32 4k;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString config.services.ombi.port}/";
        };
      };

      "jellyfin.dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096/";
        };

        locations."/socket" = {
          proxyPass = "http://127.0.0.1:8096/";
          proxyWebsockets = true;
        };
      };

      "jellyfin-dev.dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8097/";
        };

        locations."/socket" = {
          proxyWebsockets = true;
        };
      };

      "r.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:7878/";
        };
      };

      "s.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8989/";
        };
      };

      "nc.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "https://127.0.0.1:1010/";
          extraConfig = ''
            client_max_body_size 10G;
            client_body_buffer_size 400M;
          '';
        };
      };

      "sab.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8081/";
        };
      };

      "t.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9091/";
          basicAuthFile = "/run/agenix/transmission-auth";
        };
      };

      "sk.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8111/";
        };
      };

      "tt.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8181/";
        };
      };

      "cache.nix.dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
        };
      };

      "hydra.nix.dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          # proxyPass = "http://${toString config.services.hydra.listenHost}:${toString config.services.hydra.port}";
          proxyPass = "http://localhost:3000";
          extraConfig = ''
            proxy_set_header  Host              $host;
            proxy_set_header  X-Real-IP         $remote_addr;
            proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header  X-Forwarded-Proto $scheme;
          '';
        };
      };

      "home.dgb.sh" = {
        forceSSL = true;

        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8123/";
          extraConfig = ''
            proxy_redirect   http://    https://;
            proxy_set_header Host       $host;
            proxy_set_header X-Real-IP  $remote_addr;
            proxy_set_header Upgrade    $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      };
    };
  };

  users.users.nginx = {
    extraGroups = [ "agenix" ]; # secrets access
  };
}
