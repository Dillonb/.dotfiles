{ lib, ... }:
{
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  networking.useDHCP = lib.mkDefault true;

  nix.settings.trusted-users = [ "dillon" ];

  system.stateVersion = "24.05";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };
}
