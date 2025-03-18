{ pkgs, config, inputs, ... }:
let
  optionals = pkgs.lib.optionals;
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  isX64 = pkgs.stdenv.isx86_64;

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
    lm_sensors

    # Misc utils
    usbutils # for lsusb
    pciutils # for lspci
    nvme-cli
    smartmontools
    vtm
  ]);

  # Mac specific
  darwinPkgs = optionals isDarwin (with pkgs; [
    # these programs are installed through programs.whatever.enable on Linux, but that is unavailable on Darwin, so install manually
    git
    git-lfs
    mosh
    unstable.neovim
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
    bear
    unstable.bash-language-server
    lazygit
    nuget
    powershell
    nodejs

    # Theming
    unstable.oh-my-posh

    # System status
    htop
    btop
    neofetch
    nload
    ncdu

    # Misc utils
    wget
    fzf
    tmux
    silver-searcher
    bat
    dos2unix
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
    unstable.nix-search-tv
    television

    # Fun
    fortune
    dwt1-shell-color-scripts
  ] ++ [
    inputs.detectcharset.packages."${pkgs.system}".default
  ] ++ (optionals isX64 [
    (asmrepl.override {
      bundlerApp = bundlerApp.override {
        ruby = ruby_3_2;
      };
    })
  ]);
in
{
  environment.systemPackages = linuxPkgs ++ darwinPkgs ++ commonPkgs;
}
