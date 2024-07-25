{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    # Browser
    # firefox # configured with programs.firefox below
    # google-chrome
    microsoft-edge

    # Mail
    unstable.mailspring
    protonmail-desktop

    # Util
    scrot
    feh
    # keymapp # flashing ZSA keyboards
    wally-cli # also for flashing ZSA keyboards (cli tool)
    master.freerdp3
    wl-clipboard # Wayland clipboard from cli
    xclip # X11 clipboard from cli

    # themes
    kde-gruvbox
    gruvbox-dark-gtk
    unstable.gruvbox-plus-icons
    capitaine-cursors-themed
    oh-my-posh

    # Gaming
    chiaki # ps5 remote play
    # lutris
    moonlight-qt

    # Terminal
    alacritty
    kitty

    # Chat
    # discord # get discord through flatpak (for now?)
    signal-desktop
    keybase-gui
    hexchat
    element-desktop
    slack

    # Dev
    master.vscode
    unstable.ghidra
    nil # nix language server
    nixpkgs-fmt
    master.sublime-merge
    imhex
    renderdoc
    zeal
    nasm
    pyright # python language server
    pipenv
    ocaml
    opam
    gdb
    lldb
    git
    python3
    docker-compose
    valgrind
    mypy
    gh
    lua-language-server
    ripgrep
    fd
    cmake-language-server

    # Sec
    tcpdump
    nmap
    burpsuite
    foremost
    hashcat
    proxmark3

    # Notes
    unstable.obsidian

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
    teamspeak5_client
    nextcloud-client
    # kicad
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
    unstable.neovim
    unstable.neovim-qt
    unstable.neovide

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
    p7zip
    pavucontrol
    distrobox

    # Fun
    fortune

    # Backup
    restic
    rclone
  ];
}
