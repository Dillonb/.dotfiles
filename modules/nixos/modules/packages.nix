{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    # Browser
    # firefox # configured with programs.firefox below
    # google-chrome
    microsoft-edge

    # Mail
    mailspring

    # Util
    scrot
    feh
    # keymapp # flashing ZSA keyboards
    wally-cli # also for flashing ZSA keyboards (cli tool)
    remmina

    # Gaming
    chiaki # ps5 remote play
    # lutris
    moonlight-qt

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
    # vscode should be used through distrobox
    ghidra
    nil # nix language server
    nixpkgs-fmt
    emacs
    sublime-merge
    imhex
    renderdoc
    zeal
    nasm
    pyright # python language server
    pipenv

    # Notes
    obsidian

    # Misc/Media
    spotify
    spotify-qt
    # plex-media-player - install plex desktop from flatpak
    mpv
    gimp
    audacity
    gnuradio
    simplescreenrecorder
    teamspeak_client
    nextcloud-client
    kicad
    virt-manager # Installed as a package to remotely connect to a machine running libvirt

    # System status
    htop
    btop
    ncdu
    neofetch
    iotop
    nethogs
    nload

    # Editor
    vim-full # vim-full includes gvim compared to the regular vim package
    neovim
    neovim-qt
    neovide

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
    usbutils # for lsusb
    pciutils # for lspci
    nix-search-cli
    nix-index
    nix-output-monitor
    file
    netcat-gnu
    iodine
    networkmanager-iodine
    tsocks
    mitmproxy
    inetutils
    asciinema
    unzip
    zip
    pavucontrol

    # Dev/Scripting
    git
    python3
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
}
