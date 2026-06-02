{
  pkgs,
  inputs,
  config,
}:
let
  optionals = pkgs.lib.optionals;
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  isPipewireEnabled = config.services.pipewire.enable;
  isMinimalSystem = config.dgbCustom.minimal;
  isGamingEnabled = config.dgbCustom.enableGaming;

  # Filter packages based on a condition.
  # `skip` is a marker that is both a boolean and a function that returns itself, allowing filters to be chained.
  skip = {
    __skip = true;
    __functor = self: _: self;
  };
  filter = condition: package: if (package ? __skip) || !condition then skip else package;

  big = filter (!isMinimalSystem);
  x64 = filter pkgs.stdenv.isx86_64;
  needsPipewire = filter isPipewireEnabled;
  gaming = filter isGamingEnabled;

  pwndbg = inputs.pwndbg.packages."${pkgs.stdenv.hostPlatform.system}".default;
  pwndbg-lldb = inputs.pwndbg.packages."${pkgs.stdenv.hostPlatform.system}".pwndbg-lldb;

  linuxWorkstationPackages = (
    optionals isLinux (
      with pkgs;
      [
        # Terminal
        # alacritty
        # kitty
        unstable.ghostty

        # Mail
        (big no-cuda.thunderbird)

        # Util
        scrot
        feh
        (big keymapp) # flashing ZSA keyboards
        (big wally-cli) # also for flashing ZSA keyboards (cli tool)
        # freerdp
        wl-clipboard # Wayland clipboard from cli
        xclip # X11 clipboard from cli
        parsec-bin
        gparted

        # Gaming
        (big stable.chiaki-ng) # ps5 remote play
        # lutris

        # Chat
        # (big unstable.vesktop)
        (big signal-desktop)
        # hexchat
        (big element-desktop)

        # Dev
        docker-compose
        (big vscode-fhs)
        (big stable.ghidra)
        sublime-merge
        # zeal
        gdb
        (big cargo)
        # (big qtcreator)

        # Sec
        tcpdump
        nmap
        # (big burpsuite)
        foremost
        (big proxmark3)
        (big pwndbg)
        (big pwndbg-lldb)
        (big pwntools)

        # Notes
        obsidian

        # Misc/Media
        (big no-cuda.gimp)
        # (big audacity)
        # gnuradio
        simplescreenrecorder
        # protonvpn-gui
        mpv

        # Editor
        # neovim-qt
        (big zed-editor)

        # Misc utils
        xkill
        # iodine
        # networkmanager-iodine
        stable.tsocks
        # mitmproxy
        pavucontrol
        # distrobox
        # posting

        # x64 only stuff
        (x64 big protonmail-desktop)
        (x64 big google-chrome)
        (x64 unstable.discord)
        (x64 big jellyfin-desktop)
        # (x64 big slack)
        # (x64 big renderdoc)
        (x64 big spotify)
        # (x64 big teamspeak3)
        (x64 big teamspeak6-client)

        (gaming x64 gamescope)
        (gaming x64 mangohud)
      ]
    )
  );

  darwinWorkstationPackages = optionals isDarwin (
    with pkgs;
    [
      mpv-unwrapped # mpv has a broken .app bundle
      # pwndbg-lldb
      nowplaying-cli
      sqlitebrowser
    ]
  );

  commonWorkstationPackages = with pkgs; [
    # Dev/Editor
    vim-full # vim-full includes gvim compared to the regular vim package
    # unstable.imhex

    # Gaming
    (big moonlight-qt)
  ];

  # Linux specific
  linuxCommonPkgs = optionals isLinux (
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
      (needsPipewire x64 easyeffects)
      (needsPipewire qpwgraph)
    ]
  );

  # Mac specific
  darwinCommonPkgs = optionals isDarwin (
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
  commonCommonPkgs =
    with pkgs;
    [
      # Dev
      nasm
      pyright # python language server
      pipenv
      python3
      mypy
      gh # github cli
      lua-language-server
      ripgrep
      fd
      bear
      bash-language-server
      lazygit
      (big nuget)
      (big powershell)
      nodejs
      delta
      (big unstable.github-copilot-cli)

      # Theming
      oh-my-posh

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
      ffmpeg
      toilet
      tree-sitter

      # Nix utils
      nixfmt
      nix-search-tv
      (big nixd) # nix language server
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
    ++ [ inputs.detectcharset.packages."${pkgs.stdenv.hostPlatform.system}".default ];

in
{
  workstationPackages = builtins.filter (pkg: !(pkg ? __skip)) (
    linuxWorkstationPackages ++ darwinWorkstationPackages ++ commonWorkstationPackages
  );

  commonPackages = builtins.filter (pkg: !(pkg ? __skip)) (
    linuxCommonPkgs ++ darwinCommonPkgs ++ commonCommonPkgs
  );
}
