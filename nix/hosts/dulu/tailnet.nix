{ config, lib, ... }:
let
  tailnetipv4 = "100.112.115.103";
  tailnetipv6 = "fd7a:115c:a1e0::4901:7367";

  tailnetOnlyNames = lib.concatLists (
    lib.mapAttrsToList (name: vhost: [ name ] ++ vhost.serverAliases) (
      lib.filterAttrs (_: vhost: vhost.tailnetOnly) config.services.nginx.virtualHosts
    )
  );
in
{
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, ... }:
        {
          options.tailnetOnly = lib.mkEnableOption "dropping non-tailnet clients (HTTP 444)";

          # Note: this shouldn't break LetsEncrypt/ACME because those are done on port 80
          config = lib.mkIf config.tailnetOnly {
            forceSSL = true;
            extraConfig = ''
              if ($dgb_from_tailnet = 0) {
                return 444;
              }
            '';
          };
        }
      )
    );
  };

  # Is the request coming from the tailnet?
  config.services.nginx.appendHttpConfig = ''
    geo $dgb_from_tailnet {
      default 0;
      100.64.0.0/10 1;
      fd7a:115c:a1e0::/48 1;
    }
  '';

  # Resolve tailnet-only names to dulu's tailnet ip
  config.services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      interface = "tailscale0";
      bind-dynamic = true;
      # We need to specify the upstream resolver explicitly here so we don't loop (ask tailscale DNS again)
      no-resolv = true;
      server = [
        "1.1.1.1"
        "9.9.9.9"
      ];
      host-record = map (name: "${name},${tailnetipv4},${tailnetipv6}") tailnetOnlyNames;

      # Never forward tailnet names to the upstream resolver
      local = map (name: "/${name}/") tailnetOnlyNames;
      local-ttl = 60;
    };
  };

  config.networking.firewall.interfaces.tailscale0 = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };
}
