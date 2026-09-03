{ config, lib, ... }:
let
  dgbCustom = config.dgbCustom;
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # IOMMU is broken on this board and causes crashes/display failures.
  # https://elektricm.github.io/amd-bc250-docs/linux/kernel/
  boot.kernelParams = [ "amd_iommu=off" ];

  hardware.bc250 = {
    enable = true;
    features = {
      sensors.enable = true;
      gpuGovernor.enable = true;
      zswap.enable = true;

      # Only needed for AIC8800D80-based WiFi dongles.
      aic8800d80.enable = false;
      cuLiveManager.enable = true;
      # Requires running `bc250-detect` first and setting cpuOverclock.configFile.
      cpuOverclock.enable = false;
      # Modded BIOSes may already provide these; enabling both conflicts.
      acpiFix.enable = false;

      # vramSplit writes UMA_SIZE to CMOS permanently - set it in the BIOS instead.
      vramSplit = null;
      vramDynamicSplit = null;
    };
  };

  jovian.steam = {
    enable = true;
    autoStart = true;
    desktopSession = "plasma";
    user = dgbCustom.username;
  };
  services.displayManager.plasma-login-manager.enable = lib.mkForce false;

  # Jovian defaults to zram, which conflicts with the bc250 module's zswap.
  jovian.steamos.enableZram = false;

  # zswap needs a backing store.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  system.stateVersion = "26.05";
}
