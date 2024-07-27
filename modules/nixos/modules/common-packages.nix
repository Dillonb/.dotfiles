{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    # Dev
    nil # nix language server
    nixpkgs-fmt
    nasm
    pyright # python language server
    pipenv
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

    # System status
    htop
    btop
    ncdu
    neofetch
    iotop
    nethogs
    nload

    # Editor
    unstable.neovim

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

    # Fun
    fortune

    # Backup
    restic
    rclone
  ];
}