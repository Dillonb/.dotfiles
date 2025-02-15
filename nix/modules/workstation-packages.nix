{ pkgs, inputs, ... }:
let
  optionals = pkgs.lib.optionals;
  isLinux = pkgs.stdenv.isLinux;
  isLinuxX64 = isLinux && pkgs.stdenv.hostPlatform.isx86_64;
  isDarwin = pkgs.stdenv.isDarwin;

  pwndbg = inputs.pwndbg.packages."${pkgs.system}".default;
  pwndbg-lldb = inputs.pwndbg.packages."${pkgs.system}".pwndbg-lldb;

  bicep-langserver = pkgs.callPackage ../packages/bicep-langserver { };

  linuxPackages = (optionals isLinux (with pkgs; [
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
    unstable.vesktop
    signal-desktop
    hexchat
    element-desktop

    # Dev
    docker-compose
    master.vscode-fhs
    stable.ghidra
    master.sublime-merge
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
    pwndbg-lldb
    pwntools

    # Notes
    unstable.obsidian

    # Misc/Media
    spotify-qt
    no-cuda.gimp
    audacity
    # gnuradio
    simplescreenrecorder
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
  ]));

  linuxX64Packages = (optionals isLinuxX64 (with pkgs; [
    # Mail
    protonmail-desktop
    (unstable.mailspring.overrideAttrs (old: {
      postFixup = ''
        substituteInPlace $out/share/applications/Mailspring.desktop \
          --replace-fail Exec=mailspring "Exec=$out/bin/mailspring --password-store=\"kwallet5\""
      '';
    }))

    google-chrome
    microsoft-edge
    unstable.discord
    unstable.plex-desktop
    slack
    renderdoc
    spotify
    teamspeak_client
    teamspeak5_client
  ]));

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
    bicep-langserver

    # Gaming
    moonlight-qt
  ];

in
{
  environment.systemPackages = linuxPackages ++ linuxX64Packages ++ darwinPackages ++ commonPackages;
}
