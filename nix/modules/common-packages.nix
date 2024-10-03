{ pkgs, inputs, ... }:
let
  optionals = pkgs.lib.optionals;
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  linuxPkgs = optionals isLinux (with pkgs; [
    # Dev
    valgrind
    gdb

    # System status
    iotop
    nethogs
    sysstat
    ncdu

    # Misc utils
    usbutils # for lsusb
    pciutils # for lspci
    nvme-cli
    smartmontools
  ]);
  macPkgs = optionals isDarwin (with pkgs; [
    # nothing yet
  ]);
  commonPkgs = with pkgs; [
    # Dev
    unstable.nixd # nix language server
    nixpkgs-fmt
    nasm
    pyright # python language server
    pipenv
    python3
    mypy
    gh
    lua-language-server
    ripgrep
    fd
    cmake-language-server
    clang-tools # for clangd
    bear
    cachix

    # System status
    htop
    btop
    neofetch
    nload

    # Editor
    unstable.neovim

    # Misc utils
    wget
    fzf
    tmux
    silver-searcher
    bat
    dos2unix
    # mosh # installed through programs.mosh.enable
    jq
    killall
    nix-search-cli
    nix-index
    nix-output-monitor
    file
    netcat-gnu
    inetutils
    asciinema
    unzip
    zip
    p7zip
    rclone
    sqlite
    sshfs
    dig
    nix-your-shell
    chezmoi
    unstable.yt-dlp
    mediainfo

    # Fun
    fortune
  ] ++ [
    inputs.detectcharset.packages."${pkgs.system}".default
  ];
in
{
  environment.systemPackages = linuxPkgs ++ macPkgs ++ commonPkgs;
}
