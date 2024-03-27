{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3b469a16-e294-41a2-a720-cef23e9a67e2";
      fsType = "ext4";
    };

  swapDevices = [ ];
  
  virtualisation.vmware.guest.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "nixos";
  # networking.interfaces.ens33.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.autossh.sessions = [
    {
      extraArguments = "-N -L9000:localhost:9000 dillon@dgb.sh";
      monitoringPort = 20000;
      name = "dgb-sh-weechat-relay";
      user = "dillon";
    }
  ];
}
