{ pkgs, ... }:
let
  optionals = pkgs.lib.optionals;
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;

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
    keymapp # flashing ZSA keyboards
    wally-cli # also for flashing ZSA keyboards (cli tool)
    master.freerdp3
    wl-clipboard # Wayland clipboard from cli
    xclip # X11 clipboard from cli
    parsec-bin

    # Gaming
    unstable.chiaki-ng # ps5 remote play
    # lutris

    # Chat
    unstable.discord
    unstable.vesktop
    signal-desktop
    hexchat
    element-desktop
    slack

    # Dev
    docker-compose
    master.vscode-fhs
    stable.ghidra
    master.sublime-merge
    renderdoc
    zeal
    ocaml
    opam
    gdb
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
    mpv

    # Editor
    unstable.neovim-qt

    # Misc utils
    xorg.xkill
    iodine
    networkmanager-iodine
    stable.tsocks
    mitmproxy
    pavucontrol
    distrobox
  ]);

  darwinPackages = optionals isDarwin (with pkgs; [
    mpv-unwrapped # mpv has a broken .app bundle
  ]);

  commonPackages = with pkgs; [
    # Terminal
    alacritty
    # kitty

    # Dev/Editor
    vim-full # vim-full includes gvim compared to the regular vim package
    unstable.neovide
    unstable.imhex

    # Gaming
    moonlight-qt
  ];

in
{
  environment.systemPackages = linuxPackages ++ darwinPackages ++ commonPackages;
}
