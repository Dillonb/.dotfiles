# Configuration specific to my desktop PC
{ config, lib, pkgs, modulesPath, ... }:

let
  dataDevusb = fetchTarball "https://github.com/devusb/nix-packages/archive/main.tar.gz";
in
{
  imports =
    [ 
      (modulesPath + "/installer/scan/not-detected.nix")
      (import "${dataDevusb}/modules/nixos/sunshine.nix")
    ];

  # Bootloader.
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/87303987-7581-4340-a158-abebfe0d02b3";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/52FB-1A5F";
      fsType = "vfat";
    };

  fileSystems."/win" =
    { device = "/dev/disk/by-uuid/E8204E89204E5F26";
      fsType = "ntfs";
    };

  fileSystems."/arch" =
    { device = "/dev/disk/by-uuid/acd118ca-367e-402f-b351-b90f3c441460";
      fsType = "ext4";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp38s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
  networking.hostName = "battlestation";
  networking.enableIPv6 = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.dpi = 109; # calculated using https://www.sven.de/dpi/ for 2560x1440 27"
  hardware.nvidia = {
    powerManagement = {
      enable = false;
      finegrained = false;
    };

    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Nvidia in Docker
  virtualisation.containers.cdi.dynamic.nvidia.enable = true;

  # VMWare Workstation
  virtualisation.vmware.host.enable = true;

  # Sunshine nvidia gamestream server
  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  # KDE Connect
  programs.kdeconnect.enable = true;

  # I dual boot Windows on this machine, so store the time in local time.
  time.hardwareClockInLocalTime = true;
}
