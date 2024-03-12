# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ config, pkgs, ... }:

let
  pkgsConfig = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0" # Needed for Obsidian
    ];
  };
  dataMaster = fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
  pkgsMaster = import (dataMaster) { config = pkgsConfig; };
in
{
  nixpkgs.config = pkgsConfig // {
    packageOverrides = pkgs: {
      vscode = pkgsMaster.vscode;
    };
  };
  imports = [ ./this-machine.nix ];

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = false;
    # alsa.enable = true;
    # alsa.support32Bit = true;
    # pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dillon = {
    isNormalUser = true;
    description = "Dillon Beliveau";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "video" "input" ];
    packages = with pkgs; [
      # Browser
      firefox
      # google-chrome
      microsoft-edge

      # Util
      _1password
      _1password-gui
      scrot
      kdePackages.kdeconnect-kde

      # Gaming
      steam
      runelite
      chiaki # ps5 remote play
      lutris
      sunshine # nvidia gamestream server

      # Terminal
      alacritty
      kitty

      # Chat
      discord
      signal-desktop
      keybase
      keybase-gui
      hexchat

      # Dev
      ghidra
      nil # nix language server
      nixpkgs-fmt
      # vscode
      emacs
      sublime-merge
      imhex
      renderdoc
      zeal

      # Notes
      obsidian

      # Misc/Media
      spotify
      plex-media-player
      mpv
      gimp
      audacity
      gnuradio
      simplescreenrecorder
      teamspeak_client
    ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # System status
    htop
    ncdu
    neofetch
    iotop
    nethogs
    nload

    # Editor
    vim
    neovim

    # Misc utils
    wget
    fzf
    direnv
    tmux
    silver-searcher
    bat
    dos2unix
    mosh
    jq
    killall
    xorg.xkill

    # Dev/Scripting
    git
    python3
    ocaml
    opam
    docker-compose
    valgrind
    mypy
    distrobox

    # Fun
    fortune

    # Backup
    restic
    rclone
  ];

  virtualisation.docker.enable = true;

  programs.nix-ld.enable = true;
  # Expose dynamic libraries in a normal location.
  # Add any missing dynamic libraries for unpackaged programs here,
  # NOT in environment.systemPackages
  programs.nix-ld.libraries = with pkgs; [
    capstone
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh.enable = true;
  programs.noisetorch.enable = true;

  # Services
  services.lorri.enable = true;
  services.openssh.enable = true;
  services.keybase.enable = true;
  services.kbfs.enable = true;

  services.locate.enable = true;
  services.locate.package = pkgs.plocate;
  # mlocate and plocate don't support this option - set it to null to silnce a warning.
  services.locate.localuser = null;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # SSH
      47990 # Sunshine webUI
      47984 47989 48010  # Sunshine
    ];
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
      { from = 47998; to = 48000; } # Sunshine
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
