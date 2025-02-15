{ pkgs, config, ... }:
{
  fileSystems."/" =
    {
      device = "/dev/mmcblk0p2";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    {
      device = "/dev/mmcblk0p1";
      fsType = "vfat";
    };

  networking.networkmanager.enable = true;

  # dgbCustom.enableGaming = false;

  boot.loader = {
    efi.canTouchEfiVariables = false;
    # timeout = null; # No timeout, wait forever
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      enable = true;
      useOSProber = true;
      device = "nodev";
      default = "saved";
      theme = pkgs.sleek-grub-theme.override {
        withBanner = config.networking.hostName;
        withStyle = "dark";
      };
    };
  };

}
