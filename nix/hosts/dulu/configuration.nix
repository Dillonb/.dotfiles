# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./restic.nix
      ./media-server.nix
      ./nginx.nix
      ./dns.nix
      ./pihole.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Support emulating arm64 binaries
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Disable SSD power management to stop / from vanishing
  # https://lore.kernel.org/linux-nvme/YnR%2FFiWbErNGXIx+@kbusch-mbp/T/
  boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" ];

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zpool" ];
  services.zfs.autoScrub.enable = true;

  virtualisation.docker.enable = true;

  networking.hostId = "ad4d1b00";
  system.stateVersion = "24.05";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 8123 8888 9999 ];
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = true;
      permit_join = false;
      serial = {
        # port = "tcp://slzb-06m.local:6638";
        port = "tcp://192.168.0.25:6638";
        baudrate = 115200;
        adapter = "ember";
        disable_led = false;
      };
      advanced.transmit_power = 20;
      mqtt = {
        server = "mqtt://localhost:1883";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    weechat
    intel-gpu-tools
  ];

  # for QSV
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime
      unstable.vpl-gpu-rt
    ];
  };

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;

    extraConfig = ''
      workgroup = DGB
      server string = smbnix
      netbios name = smbnix
      server role = standalone server
      map to guest = bad user
    '';

    shares = {
      zpool = {
        path = "/zpool";
        browseable = "yes";
        "guest ok" = "no";
        "read only" = "no";
        "create mask" = "755";
      };
    };
  };


}

