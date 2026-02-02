# Configuration specific to my desktop PC
{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  nvidia-driver = config.boot.kernelPackages.nvidiaPackages.latest;
in

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Remove when https://github.com/NixOS/nixpkgs/issues/457406 is resolved
  programs.firefox.package = pkgs.no-cuda.firefox;

  # Bootloader.
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
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
      gfxmodeBios = "1280x720";
      gfxmodeEfi = "1280x720";
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/87303987-7581-4340-a158-abebfe0d02b3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/52FB-1A5F";
    fsType = "vfat";
  };

  fileSystems."/win" = {
    device = "/dev/disk/by-uuid/34CCCB50CCCB0AD6";
    fsType = "ntfs";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp38s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
  networking.enableIPv6 = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # 24.11+
  hardware.graphics.enable = true;
  # 24.05
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.dpi = 109; # calculated using https://www.sven.de/dpi/ for 2560x1440 27"
  hardware.nvidia = {
    powerManagement = {
      enable = false;
      finegrained = false;
    };

    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = nvidia-driver;
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_EnableGpuFirmware=0"
    # "nvidia.Nvreg_PreserveVideoMemoryAllocations"
  ];

  # Nvidia in Docker
  virtualisation.docker.enableNvidia = true;
  # virtualisation.containers.cdi.dynamic.nvidia.enable = true;
  # hardware.nvidia-container-toolkit.enable = true;

  # VMWare
  # virtualisation.vmware.host.enable = true;
  # virtualisation.vmware.host.package = pkgs.stable.vmware-workstation;

  # KDE Connect
  programs.kdeconnect.enable = true;

  # I dual boot Windows on this machine, so store the time in local time.
  time.hardwareClockInLocalTime = true;

  environment.sessionVariables = {
    # Run Electron apps with native wayland instead of XWayland (buggy)
    "NIXOS_OZONE_WL" = "1";
    # Disabled for now - if stuttering comes back try reenabling
    "KWIN_DRM_DISABLE_TRIPLE_BUFFERING" = "1";
  };

  # libvirtd
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };
  programs.virt-manager.enable = true;

  services.restic = {
    backups = {
      steam-compatdata = {
        initialize = true;
        passwordFile = config.age.secrets.restic.path;
        rcloneConfigFile = "${config.services.syncthing.settings.folders."rclone-config".path}/rclone.conf";
        user = "dillon";
        paths = [ "/home/dillon/.local/share/Steam/steamapps/compatdata" ];
        repository = "rclone:b2-media:restic-steam-compatdata";
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];
        timerConfig = {
          OnCalendar = "23:00";
          # RandomizedDelaySec = "5h";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    r2modman
    # obs-studio
    prismlauncher
    godot-mono
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "23.11";
}
