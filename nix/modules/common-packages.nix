{
  pkgs,
  config,
  inputs,
  ...
}:
let
  optionals = pkgs.lib.optionals;
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  isX64 = pkgs.stdenv.isx86_64;

  isMinimalSystem = config.dgbCustom.minimal;
  big = package: if isMinimalSystem then null else package;

  # Linux specific
  linuxPkgs = optionals isLinux (
    with pkgs;
    [
      # Dev
      (big valgrind)
      (big gdb)

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
    ]
  );

  # Mac specific
  darwinPkgs = optionals isDarwin (
    with pkgs;
    [
      # these programs are installed through programs.whatever.enable on Linux, but that is unavailable on Darwin, so install manually
      git
      git-lfs
      mosh
      unstable.neovim
      coreutils-prefixed # GNU coreutils - prefixed with g
    ]
  );

  # Linux and Mac
  commonPkgs =
    with pkgs;
    [
      # Dev
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
      (big nuget)
      powershell
      nodejs
      (big bun)

      # Theming
      unstable.oh-my-posh

      # System status
      htop
      btop
      fastfetch
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
      chezmoi
      (big unstable.yt-dlp)
      mediainfo
      television
      nvd
      fend
      zoxide
      zstd
      dua
      difftastic

      # Nix utils
      nixfmt-rfc-style
      unstable.nix-search-tv
      (big unstable.nixd) # nix language server
      nix-tree
      statix
      nix-search-cli
      nix-index
      nix-output-monitor
      nix-your-shell

      # Fun
      fortune
      dwt1-shell-color-scripts
    ]
    ++ [ inputs.detectcharset.packages."${pkgs.system}".default ]
    ++ (optionals isX64 [
      (big (asmrepl.override { bundlerApp = bundlerApp.override { ruby = ruby_3_2; }; }))
    ]);
in
{
  environment.systemPackages = builtins.filter (pkg: pkg != null) (
    linuxPkgs ++ darwinPkgs ++ commonPkgs
  );
}
