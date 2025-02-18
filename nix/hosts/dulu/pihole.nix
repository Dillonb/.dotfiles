{ ... }:
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.pihole = {
      image = "pihole/pihole:2025.02.0";

      ports = [
        "53:53/tcp"
        "53:53/udp"
        "3080:80"
      ];

      volumes = [
        "/var/lib/pihole/pihole:/etc/pihole/"
        "/var/lib/pihole/dnsmasq.d:/etc/dnsmasq.d/"
      ];

      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--dns=127.0.0.1"
        "--dns=8.8.4.4"
      ];

      workdir = "/var/lib/pihole/";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 3080 ];
  };
}
