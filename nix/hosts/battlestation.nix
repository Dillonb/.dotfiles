# Configuration specific to my desktop PC
{ config, lib, modulesPath, pkgs, ... }:
let
  # nvidia_555_58_02 = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #   version = "555.58.02";
  #   sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
  #   sha256_aarch64 = "sha256-wb20isMrRg8PeQBU96lWJzBMkjfySAUaqt4EgZnhyF8=";
  #   openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
  #   settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
  #   persistencedSha256 = "sha256-a1D7ZZmcKFWfPjjH1REqPM5j/YLWKnbkP9qfRyIyxAw=";
  # };
  # nvidia_560_35_03 = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #   version = "560.35.03";
  #   sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
  #   sha256_aarch64 = "sha256-s8ZAVKvRNXpjxRYqM3E5oss5FdqW+tv1qQC2pDjfG+s=";
  #   openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
  #   settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
  #   persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";
  # };
  # nvidia_560_31_02 = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #   version = "560.31.02";
  #   sha256_64bit = "sha256-0cwgejoFsefl2M6jdWZC+CKc58CqOXDjSi4saVPNKY0=";
  #   sha256_aarch64 = "sha256-m7da+/Uc2+BOYj6mGON75h03hKlIWItHORc5+UvXBQc=";
  #   openSha256 = "sha256-X5UzbIkILvo0QZlsTl9PisosgPj/XRmuuMH+cDohdZQ=";
  #   settingsSha256 = "sha256-A3SzGAW4vR2uxT1Cv+Pn+Sbm9lLF5a/DGzlnPhxVvmE=";
  #   persistencedSha256 = "sha256-BDtdpH5f9/PutG3Pv9G4ekqHafPm3xgDYdTcQumyMtg=";
  # };
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
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
      theme = pkgs.sleek-grub-theme.override {
        withBanner = "battlestation";
        withStyle = "dark";
      };
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/87303987-7581-4340-a158-abebfe0d02b3";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/52FB-1A5F";
      fsType = "vfat";
    };

  fileSystems."/win" =
    {
      device = "/dev/disk/by-uuid/E8204E89204E5F26";
      fsType = "ntfs";
    };

  fileSystems."/secondary" =
    {
      device = "/dev/disk/by-uuid/acd118ca-367e-402f-b351-b90f3c441460";
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
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    # package = nvidia_555_58_02;
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
  virtualisation.vmware.host.enable = true;

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
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  services.restic = {
    backups = {
      steam-compatdata = {
        initialize = true;
        passwordFile = config.age.secrets.restic.path;
        rcloneConfigFile = "${config.services.syncthing.settings.folders."rclone-config".path}/rclone.conf";
        user = "dillon";
        paths = [
          "/home/dillon/.local/share/Steam/steamapps/compatdata"
        ];
        repository = "rclone:proton:restic-backups/battlestation-steam-compatdata";
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
    master.r2modman
    no-cuda.obs-studio
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.alvr = {
    enable = true;
    package = (pkgs.callPackage ../packages/alvr {});
    openFirewall = true;
  };
}
