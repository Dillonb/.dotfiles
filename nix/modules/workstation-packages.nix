{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Browser
    # firefox # configured with programs.firefox below
    google-chrome
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
    parsec-bin

    # themes
    kde-gruvbox
    gruvbox-dark-gtk
    # unstable.gruvbox-plus-icons
    capitaine-cursors-themed
    unstable.oh-my-posh

    # Gaming
    unstable.chiaki-ng # ps5 remote play
    # lutris
    moonlight-qt

    # Terminal
    alacritty
    # kitty

    # Chat
    unstable.discord
    unstable.vesktop
    signal-desktop
    keybase-gui
    hexchat
    element-desktop
    slack

    # Dev
    docker-compose
    master.vscode-fhs
    master.ghidra
    master.sublime-merge
    unstable.imhex
    renderdoc
    zeal
    ocaml
    opam
    gdb
    lldb
    cargo
    qtcreator

    # Sec
    tcpdump
    nmap
    burpsuite
    foremost
    hashcat
    proxmark3
    pwndbg
    pwntools

    # Notes
    unstable.obsidian

    # Misc/Media
    spotify
    spotify-qt
    unstable.plex-desktop
    mpv
    no-cuda.gimp
    audacity
    # gnuradio
    simplescreenrecorder
    teamspeak_client
    teamspeak5_client
    nextcloud-client
    protonvpn-gui

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
