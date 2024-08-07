{ lib, ... }:
{
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  networking.useDHCP = lib.mkDefault true;

  nix.settings.trusted-users = [ "dillon" ];

  system.stateVersion = "24.05";
}
