{ ... }:
{
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/d5e9bfe4-c922-4dc0-bad9-b9a58b54bd6e";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/D23F-4093";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  virtualisation.vmware.guest.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
