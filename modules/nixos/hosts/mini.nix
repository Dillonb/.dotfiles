# Configuration specific to my laptop
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      # https://github.com/NixOS/nixos-hardware/tree/master/dell/xps/13-9300
      # (import "${nixosHardware}/dell/xps/13-9300/default.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Actual value calculated using https://www.sven.de/dpi/ for 1920x1200 13"
  # services.xserver.dpi = 174;
  # Same value as in battlestation.nix. Real value makes everything way too big.
  services.xserver.dpi = 109;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4ac1cbed-dc0a-4bc4-8ec7-70570076ca78";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-2016fdc0-97f6-4b06-8dc1-5ac49bf0c86e" = {
    device = "/dev/disk/by-uuid/2016fdc0-97f6-4b06-8dc1-5ac49bf0c86e";
    allowDiscards = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DE9C-875E";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };


  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Fingerprint reader
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  environment.systemPackages = with pkgs; [
    acpi
  ];

  # dgbCustom.alacritty.fontSize = 9;

}
