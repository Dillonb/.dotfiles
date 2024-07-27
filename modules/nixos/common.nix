{pkgs, ... }:
{
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

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

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
  nix.settings.trusted-users = [ "@wheel" ];

  programs = {
    zsh.enable = true;
    nh.enable = true;
  };

  services = {
    openssh.enable = true;
    lorri.enable = true;
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

  security.sudo.wheelNeedsPassword = false;

}
