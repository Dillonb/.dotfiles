{ config, pkgs, fetchFromGitHub, ... }:

let
    python3-packages = python-packages: with python-packages; [
        requests
        pip
        pyyaml
        black
        dateutil
        termcolor
        boto
        boto3
        pymysql
        mysql-connector
        setuptools
    ];

    python3-myconfig = pkgs.python37.withPackages python3-packages;
in
{
    nixpkgs = {
        config = {
            allowUnfree = true;
        };
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
        #pkgs.amazon-ecs-cli
        #pkgs.aws-sam-cli
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
        pkgs.terraform-landscape
        pkgs.tmux
        pkgs.jq
        pkgs.gnused
        pkgs.rustup
        pkgs.redis
        python3-myconfig
        #pkgs.gimp
        pkgs.links2
        pkgs.rename
        pkgs.mosh
        pkgs.protobuf
        pkgs.fzf
        pkgs.cmake
        pkgs.mypy
        pkgs.hy
        pkgs.dos2unix
        #pkgs.valgrind
        pkgs.yarn
        pkgs.qemu
        pkgs.nim
        pkgs.gource
        pkgs.q-text-as-data
        pkgs.broot
        #pkgs.pipenv # Broken last time I tried it
        pkgs.leiningen

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
        pkgs.jd-gui

        pkgs.offlineimap
    ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
