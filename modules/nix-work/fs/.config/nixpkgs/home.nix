{ config, pkgs, fetchFromGitHub, ... }:

{
    nixpkgs = {
        overlays = [
            (self: super: {
                fortune-mod = super.lowPrio super.fortune-mod;

                terraform = super.terraform.overrideAttrs (attrs: {
                    version = "0.11.13";
                    src = pkgs.fetchFromGitHub {
                        owner  = "hashicorp";
                        repo   = "terraform";
                        # Both rev and sha256 need to be updated here - just updating rev is not enough to force nix to build the new version
                        rev    = "v0.11.13";
                        sha256 = "014d2ibmbp5yc1802ckdcpwqbm5v70xmjdyh5nadn02dfynaylna";
                    };
                });
            })
        ];
    };


    home.packages = [
        pkgs.bat
        pkgs.ncdu
        pkgs.fortune
        pkgs.awscli
        pkgs.coreutils
        pkgs.direnv
        pkgs.emacs
        pkgs.findutils
        pkgs.git
        pkgs.htop
        pkgs.mysql
        pkgs.rclone
        pkgs.restic
        pkgs.silver-searcher
        pkgs.watch
        pkgs.wget
        pkgs.zsh
        pkgs.terraform
        pkgs.tmux
        pkgs.jq
        pkgs.gnused
        pkgs.rustup

        # Containers
        pkgs.docker
        pkgs.docker-compose
        pkgs.kubectl
        pkgs.aws-iam-authenticator

        # Keyboard
        pkgs.avrdude
        #pkgs.avrgcc
        #pkgs.avrbinutils

        # GUI
        pkgs.visualvm
        #pkgs.plex-media-player
    ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
