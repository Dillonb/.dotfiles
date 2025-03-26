# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, config, ... }:

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
      ./smart-home.nix
      ./github-runner.nix
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
    allowedTCPPorts = [ 22 80 443 ];
  };

  environment.systemPackages = with pkgs; [
    weechat
    intel-gpu-tools
  ];

  # for QSV
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
  ];
  hardware.graphics = {
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

  services.samba =
    let
      shareTemplate = {
        browseable = "yes";
        writable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "force group" = "users";
        "valid users" = "dillon";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    in
    {
      package = pkgs.samba4Full; # samba4Full has avahi, ldap, AD, etc, needed so Samba can register mDNS records
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          security = "user";
          "workgroup" = "DGB";
          "server string" = "dulu";
          "netbios name" = "dulu";
          "server role" = "standalone server";
          "map to guest" = "bad user";
          "server min protocol" = "SMB3";

          # Needed for Time Machine
          "vfs objects" = "catia fruit streams_xattr";
          "fruit:aapl" = "yes";
          "fruit:nfs_aces" = "no";
          "fruit:model" = "TimeCapsule8,119";
          "fruit:resource" = "xattr";
          "fruit:metadata" = "stream";
          "fruit:veto_appledouble" = "no";
          "fruit:posix_rename" = "yes";
          "fruit:zero_file_id" = "yes";
          "fruit:wipe_intentionally_left_blank_rfork" = "yes";
          "fruit:delete_empty_adfiles" = "yes";
          "fruit:encoding" = "native";
          "readdir_attr:aapl_finder_info" = "no";
          "readdir_attr:aapl_rsize" = "no";

        };
        zpool = shareTemplate // {
          path = "/zpool";
        };
        "TimeMachine" = shareTemplate // {
          path = "/zpool/timemachine";
          "fruit:time machine" = "yes";
        };
        homes = {
          browseable = "yes";
          "valid users" = "%S";
          writable = "yes";
          "read only" = "no";
        };
      };
    };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
    };
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = config.age.secrets."nix-cache-priv-key.pem".path;
    port = 5001;
  };
}

