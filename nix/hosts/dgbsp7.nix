{ lib, config, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/80a280d3-7db0-4b4c-91dc-69f24ac32346";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-94f72c25-0472-4680-b5dd-945bf695217e" = {
    device = "/dev/disk/by-uuid/94f72c25-0472-4680-b5dd-945bf695217e";
    allowDiscards = true;
  };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/EA43-1DC8";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  virtualisation.waydroid.enable = true;

  dgbCustom = {
    enableGaming = true;
    minimal = true;
  };
}
