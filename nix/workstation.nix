{ pkgs, config, ... }:

{
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  hardware = {
    # SDR device udev rules
    hackrf.enable = true;
    rtl-sdr.enable = true;
    # ZSA keyboard udev rule
    keyboard.zsa.enable = true;

    # udev rules and software for configuring logitech unifying recivers
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs = {
    nix-ld.enable = true;

    zsh.enable = true;

    firefox.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      # Needed so the browser extension can interact with the application and with system auth
      polkitPolicyOwners = [ "dillon" ];
    };

    steam = pkgs.lib.mkIf (config.dgbCustom.enableGaming && pkgs.stdenv.hostPlatform.isx86_64) {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      extraCompatPackages = with pkgs; [ proton-ge-bin ];

      # Because steam-run is the best way to get unusual binaries to run
      extraPackages = with pkgs; [ libxml2 ];
    };

    gamemode = pkgs.lib.mkIf (config.dgbCustom.enableGaming && pkgs.stdenv.hostPlatform.isx86_64) {
      enable = true;
    };

    wireshark.enable = true;
    dconf.enable = true; # for home-manager

    xwayland.enable = true;
  };

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "scheme-handler/https" = "firefox.desktop";
    };
  };
  # Cover all my bases
  environment.sessionVariables.BROWSER = "firefox";
  environment.sessionVariables.DEFAULT_BROWSER = "firefox";

  # Services
  services = {
    # "discouraged" to turn this off, but Steam downloads are very slow with this on.
    # nscd.enableNsncd = false;
    resolved.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
