{ pkgs, system, inputs, ... }:
let
  optionals = pkgs.lib.optionals;
  isLinux = pkgs.stdenv.isLinux;
  # isDarwin = pkgs.stdenv.isDarwin;

  custom-node-pkgs = import ../packages/node-packages {
    inherit pkgs system;
  };

  # Linux specific
  linuxPkgs = optionals isLinux (with pkgs; [
    # Dev
    valgrind
    gdb
    cmake-language-server # broken on macos

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

  # Linux and Mac
  commonPkgs = with pkgs; [
    # Dev
    unstable.nixd # nix language server
    nixpkgs-fmt
    nasm
    pyright # python language server
    pipenv
    python3
    mypy
    gh # github cli
    hub # another github cli
    lua-language-server
    ripgrep
    fd
    clang-tools # for clangd
    bear
    cachix
    unstable.bash-language-server
    custom-node-pkgs.azure-pipelines-language-server
    custom-node-pkgs."@mistweaverco/kulala-ls"

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
    node2nix

    # Fun
    fortune
    dwt1-shell-color-scripts
  ] ++ [
    inputs.detectcharset.packages."${pkgs.system}".default
  ];
in
{
  environment.systemPackages = linuxPkgs ++ commonPkgs;
}
