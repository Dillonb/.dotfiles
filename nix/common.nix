{ pkgs, ... }:
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
      auto-optimise-store = true;

      substituters = [
        "https://cache.nix.dgb.sh"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];

      trusted-public-keys = [
        "cache.nix.dgb.sh:XzJS7VYoZ90T3fwKySBAqfKdxViX6zk2PJvlKVD+euU="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    # package = pkgs.lix;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.dillon = {
      isNormalUser = true;
      description = "Dillon Beliveau";
      extraGroups = [
        # Should be self explanatory
        "networkmanager"
        "wheel"
        "docker"
        "podman"
        "audio"
        "video"
        "render"
        "input"
        "wireshark"
        "libvirtd"
        # for SDR/logitech unifying
        "plugdev"
        # Access to secrets
        "agenix"
        # Access to syncthing data
        "syncthing"
      ];
    };
  };
  nix.settings.trusted-users = [ "@wheel" ];

  programs = {
    zsh.enable = true;
    nh.enable = true;
    direnv.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    mosh = {
      enable = true;
      openFirewall = true;
    };
    bandwhich.enable = true;

    neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
      defaultEditor = true;

      # Tell nvim where GCC is. Needed so it can compile the treesitter parsers.
      # Then load the normal init.lua file
      configure = {
        customRC = ''
          let g:gcc_bin_path = '${pkgs.lib.getExe pkgs.gcc}'
          luafile ~/.config/nvim/init.lua
        '';
      };
    };
  };

  services = {
    openssh.enable = true;
    locate = {
      enable = true;
      package = pkgs.plocate;
    };
    tailscale.enable = true;
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # SSH
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  security.acme = {
    acceptTerms = true;
    defaults.email = "dillonbeliveau@gmail.com";
  };
}
