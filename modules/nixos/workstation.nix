{ pkgs, ... }:

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

  # SDR device udev rules
  hardware.hackrf.enable = true;
  hardware.rtl-sdr.enable = true;
  # ZSA keyboard udev rule
  hardware.keyboard.zsa.enable = true;

  fonts.packages = with pkgs; [
      hasklig
      terminus_font
      dejavu_fonts
      hack-font
      noto-fonts-cjk
      noto-fonts-cjk-sans
      cascadia-code
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  programs = {
    nix-ld.enable = true;
    # Expose dynamic libraries in a normal location.
    # Add any missing dynamic libraries for unpackaged programs here,
    # NOT in environment.systemPackages
    nix-ld.libraries = with pkgs; [
      capstone
    ];

    zsh.enable = true;
    thefuck.enable = true;

    firefox.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      # Needed so the browser extension can interact with the application and with system auth
      polkitPolicyOwners = [ "dillon" ];
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    wireshark.enable = true;
    dconf.enable = true; # for home-manager
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
    keybase.enable = true;
    kbfs.enable = true;
    # "discouraged" to turn this off, but Steam downloads are very slow with this on.
    nscd.enableNsncd = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
