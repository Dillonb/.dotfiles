# Configuration specific to my laptop
{ config, lib, pkgs, modulesPath, ... }:

let
  nixosHardware = fetchTarball "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz";
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      # https://github.com/NixOS/nixos-hardware/tree/master/dell/xps/13-9300
      (import "${nixosHardware}/dell/xps/13-9300/default.nix")
      ./modules/bluetooth.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Actual value calculated using https://www.sven.de/dpi/ for 1920x1200 13"
  # services.xserver.dpi = 174;
  # Same value as in battlestation.nix. Real value makes everything way too big.
  services.xserver.dpi = 109;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f0731786-5488-4f0d-90c3-836f780198a7";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-012dae05-3772-4220-8e2e-25e0a762eb65".device = "/dev/disk/by-uuid/012dae05-3772-4220-8e2e-25e0a762eb65";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8B3A-0B76";
      fsType = "vfat";
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
  hardware.opengl.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mini"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Fingerprint reader
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

}
