{ pkgs, ... }:
let
  optionals = pkgs.lib.optionals;
  isLinux = pkgs.stdenv.isLinux;
  # isDarwin = pkgs.stdenv.isDarwin;

  linuxPackages = optionals isLinux (with pkgs; [
    # Browser
    # firefox # configured with programs.firefox below
    google-chrome
    microsoft-edge

    # Mail
    (unstable.mailspring.overrideAttrs (old: {
      postFixup = ''
      substituteInPlace $out/share/applications/Mailspring.desktop \
        --replace-fail Exec=mailspring "Exec=$out/bin/mailspring --password-store=\"kwallet5\""
      '';
    }))
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

    # Gaming
    unstable.chiaki-ng # ps5 remote play
    # lutris
    moonlight-qt

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
    no-cuda.gimp
    audacity
    # gnuradio
    simplescreenrecorder
    teamspeak_client
    teamspeak5_client
    nextcloud-client
    protonvpn-gui

    # Editor
    unstable.neovim-qt

    # Misc utils
    xorg.xkill
    iodine
    networkmanager-iodine
    tsocks
    mitmproxy
    pavucontrol
    distrobox
  ]);

  commonPackages = with pkgs; [
    # Terminal
    alacritty
    # kitty

    # Dev/Editor
    vim-full # vim-full includes gvim compared to the regular vim package
    unstable.neovide
    unstable.imhex

    # Misc/Media
    mpv
  ];

in
{
  environment.systemPackages = linuxPackages ++ commonPackages;
}
