{ pkgs, inputs, config, ... }:
let
  optionals = pkgs.lib.optionals;
  isLinux = pkgs.stdenv.isLinux;
  isLinuxX64 = isLinux && pkgs.stdenv.hostPlatform.isx86_64;
  isLinuxArm64 = isLinux && pkgs.stdenv.hostPlatform.isAarch64;
  isDarwin = pkgs.stdenv.isDarwin;

  isMinimalSystem = config.dgbCustom.minimal;
  big = package: if isMinimalSystem then null else package;

  pwndbg = inputs.pwndbg.packages."${pkgs.system}".default;
  pwndbg-lldb = inputs.pwndbg.packages."${pkgs.system}".pwndbg-lldb;

  linuxPackages = (optionals isLinux (with pkgs; [
    # Terminal
    alacritty
    # kitty
    ghostty

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
    cachix
    docker-compose
    master.vscode-fhs
    (big stable.ghidra)
    master.sublime-merge
    zeal
    ocaml
    opam
    gdb
    (big cargo)
    (big qtcreator)

    # Sec
    tcpdump
    nmap
    (big burpsuite)
    foremost
    hashcat
    proxmark3
    (big pwndbg)
    (big pwndbg-lldb)
    (big pwntools)

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
    (big protonmail-desktop)
    (big (unstable.mailspring.overrideAttrs (old: {
      postFixup = ''
        substituteInPlace $out/share/applications/Mailspring.desktop \
          --replace-fail Exec=mailspring "Exec=$out/bin/mailspring --password-store=\"kwallet5\""
      '';
    })))

    (big google-chrome)
    (big microsoft-edge)
    unstable.discord
    (big unstable.plex-desktop)
    (big slack)
    (big renderdoc)
    spotify
    teamspeak_client
    teamspeak5_client
  ]));

  darwinPackages = optionals isDarwin (with pkgs; [
    mpv-unwrapped # mpv has a broken .app bundle
    pwndbg-lldb
  ]);

  commonPackages = with pkgs; [
    # Dev/Editor
    vim-full # vim-full includes gvim compared to the regular vim package
    unstable.neovide
    unstable.imhex
    bicep

    # Gaming
    moonlight-qt
  ];

in
{
  environment.systemPackages = builtins.filter (pkg: pkg != null) (linuxPackages ++ linuxX64Packages ++ darwinPackages ++ commonPackages);
}
