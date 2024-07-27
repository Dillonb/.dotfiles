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
    docker-compose
    master.vscode
    unstable.ghidra
    master.sublime-merge
    imhex
    renderdoc
    zeal
    ocaml
    opam
    gdb
    lldb

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
    unstable.neovim-qt
    unstable.neovide

    # Misc utils
    xorg.xkill
    iodine
    networkmanager-iodine
    tsocks
    mitmproxy
    pavucontrol
    distrobox
  ];
}
