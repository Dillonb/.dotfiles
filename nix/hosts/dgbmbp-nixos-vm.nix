{ ... }:
{
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/54623f08-da1c-46fa-a9e8-9faf110bfd86";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/143A-D0E1";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  virtualisation.vmware.guest.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
