# Configuration specific to my desktop PC
{ config, lib, modulesPath, pkgs, ... }:

let
  nvidia_555_58 = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "555.58";
    sha256_64bit = "sha256-bXvcXkg2kQZuCNKRZM5QoTaTjF4l2TtrsKUvyicj5ew=";
    sha256_aarch64 = "sha256-7XswQwW1iFP4ji5mbRQ6PVEhD4SGWpjUJe1o8zoXYRE=";
    openSha256 = "sha256-hEAmFISMuXm8tbsrB+WiUcEFuSGRNZ37aKWvf0WJ2/c=";
    settingsSha256 = "sha256-vWnrXlBCb3K5uVkDFmJDVq51wrCoqgPF03lSjZOuU8M=";
    persistencedSha256 = "sha256-lyYxDuGDTMdGxX3CaiWUh1IQuQlkI2hPEs5LI20vEVw=";
  };
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./modules/sunshine.nix
      ./modules/bluetooth.nix
    ];

  # Bootloader.
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.loader = {
    efi.canTouchEfiVariables = false;
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      enable = true;
      useOSProber = true;
      device = "nodev";
      default = "saved";
    };
  };

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

  fileSystems."/secondary" =
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
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    package = nvidia_555_58;
  };

  # boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];

  # udev rules and software for configuring logitech unifying recivers
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # Nvidia in Docker
  virtualisation.docker.enableNvidia = true;
  # virtualisation.containers.cdi.dynamic.nvidia.enable = true;
  # hardware.nvidia-container-toolkit.enable = true;

  # KDE Connect
  programs.kdeconnect.enable = true;

  # I dual boot Windows on this machine, so store the time in local time.
  time.hardwareClockInLocalTime = true;

  # Fixes some Wayland stuff on Nvidia
  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  # libvirtd
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
            }).fd];
      };
    };
  };
}
