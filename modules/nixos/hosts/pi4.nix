{ ... }:
{
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  networking = {
    interfaces.end0 = {
      ipv4.addresses = [{
        address = "192.168.0.100";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.1"; # or whichever IP your router is
        interface = "end0";
    };
    nameservers = [
      "192.168.1.1" # or whichever DNS server you want to use
    ];
  };

  nix.settings.trusted-users = [ "dillon" ];

  system.stateVersion = "24.05";
}
