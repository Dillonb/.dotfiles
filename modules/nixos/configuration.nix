{ pkgs, lib, ... }:

let
  pkgsConfig = {
    allowUnfree = true;
    permittedInsecurePackages = [
    ];
  };
  dataUnstable = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  pkgsUnstable = import (dataUnstable) { config = pkgsConfig; };

  dataMaster = fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
  pkgsMaster = import (dataMaster) { config = pkgsConfig; };

  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  nixpkgs.config = pkgsConfig // {
    packageOverrides = pkgs: {
      vscode = pkgsMaster.vscode-fhs;
      obsidian = pkgsUnstable.obsidian;
      sublime-merge = pkgsMaster.sublime-merge;
      ghidra = pkgsUnstable.ghidra;
      keybase = pkgsUnstable.keybase;
      keybase-gui = pkgsUnstable.keybase-gui;
      kbfs = pkgsUnstable.kbfs;
      mailspring = pkgsUnstable.mailspring;
      gruvbox-plus-icons = pkgsUnstable.gruvbox-plus-icons;
      neovim = pkgsUnstable.neovim;
      neovim-qt = pkgsUnstable.neovim-qt;
      neovide = pkgsUnstable.neovide;
    };
  };
  imports = [
    ./this-machine.nix
    "${home-manager}/nixos"
    ./modules/custom-options.nix
    ./modules/flatpak-support.nix
    ./modules/ime.nix
    ./modules/kde.nix
    ./modules/pulseaudio.nix
    # ./modules/pipewire.nix
    ./modules/home-manager.nix
    ./modules/packages.nix
    ./modules/appimage-support.nix
    ./modules/libreoffice.nix
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.dillon = {
      isNormalUser = true;
      description = "Dillon Beliveau";
      extraGroups = [
        # Should be self explanatory
        "networkmanager" "wheel" "docker" "audio" "video" "input" "wireshark" "libvirtd"
        # for SDR/logitech unifying
        "plugdev"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

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
    noisetorch.enable = true;
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
    lorri.enable = true;
    openssh.enable = true;
    keybase.enable = true;
    kbfs.enable = true;
    # "discouraged" to turn this off, but Steam downloads are very slow with this on.
    nscd.enableNsncd = false;

    locate = {
      enable = true;
      package = pkgs.plocate;
      # mlocate and plocate don't support this option - set it to null to silence a warning.
      localuser = null;
    };
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # SSH
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
