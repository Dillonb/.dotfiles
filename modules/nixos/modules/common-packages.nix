{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Dev
    unstable.nixd # nix language server
    nixpkgs-fmt
    nasm
    pyright # python language server
    pipenv
    python3
    valgrind
    mypy
    gh
    lua-language-server
    ripgrep
    fd
    cmake-language-server

    # System status
    htop
    btop
    ncdu
    neofetch
    iotop
    nethogs
    nload
    sysstat

    # Editor
    unstable.neovim

    # Misc utils
    wget
    fzf
    tmux
    silver-searcher
    bat
    dos2unix
    mosh
    jq
    killall
    usbutils # for lsusb
    pciutils # for lspci
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
    nvme-cli
    smartmontools
    sqlite
    sshfs

    # Fun
    fortune
  ];
}
