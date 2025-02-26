{ pkgs, config, ... }:
{
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/1f2c0e78-6e81-443d-b767-f336207369aa";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/E539-193F";
      fsType = "vfat";
    };

  networking.networkmanager.enable = true;

  dgbCustom = {
    enableGaming = false;
    minimal = true;
  };

  boot.loader = {
    efi.canTouchEfiVariables = false;
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
