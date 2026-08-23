# Asrock AMD BC-250 (Cyan Skillfish APU)
{ ... }:

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
      # Test stability of the CU unlock before enabling.
      cuLiveManager.enable = false;
      # Requires running `bc250-detect` first and setting cpuOverclock.configFile.
      cpuOverclock.enable = false;
      # Modded BIOSes may already provide these; enabling both conflicts.
      acpiFix.enable = false;

      # vramSplit writes UMA_SIZE to CMOS permanently - set it in the BIOS instead.
      vramSplit = null;
      vramDynamicSplit = null;
    };
  };

  # zswap needs a backing store.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  system.stateVersion = "26.05";
}
