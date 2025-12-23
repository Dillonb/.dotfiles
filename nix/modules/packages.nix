{
  pkgs,
  inputs,
  config,
}:
let
  optionals = pkgs.lib.optionals;
  isLinux = pkgs.stdenv.isLinux;
  isX64 = pkgs.stdenv.isx86_64;
  isLinuxX64 = isLinux && isX64;
  # isLinuxArm64 = isLinux && pkgs.stdenv.hostPlatform.isAarch64;
  isDarwin = pkgs.stdenv.isDarwin;

  isMinimalSystem = config.dgbCustom.minimal;
  big = package: if isMinimalSystem then null else package;

  pwndbg = inputs.pwndbg.packages."${pkgs.stdenv.hostPlatform.system}".default;
  pwndbg-lldb = inputs.pwndbg.packages."${pkgs.stdenv.hostPlatform.system}".pwndbg-lldb;

  linuxWorkstationPackages = (
    optionals isLinux (
      with pkgs;
      [
        # Terminal
        alacritty
        # kitty
        ghostty

        # Util
        scrot
        feh
        (big keymapp) # flashing ZSA keyboards
        (big wally-cli) # also for flashing ZSA keyboards (cli tool)
        unstable.freerdp
        wl-clipboard # Wayland clipboard from cli
        xclip # X11 clipboard from cli
        parsec-bin
        gparted

        # Gaming
        unstable.chiaki-ng # ps5 remote play
        # lutris

        # Chat
        # (big unstable.vesktop)
        (big signal-desktop)
        hexchat
        (big element-desktop)

        # Dev
        docker-compose
        (big unstable.vscode-fhs)
        (big stable.ghidra)
        unstable.sublime-merge
        # zeal
        gdb
        (big cargo)
        # (big qtcreator)

        # Sec
        tcpdump
        nmap
        (big burpsuite)
        foremost
        (big proxmark3)
        (big pwndbg)
        (big pwndbg-lldb)
        (big pwntools)

        # Notes
        unstable.obsidian

        # Misc/Media
        (big no-cuda.gimp)
        # (big audacity)
        # gnuradio
        simplescreenrecorder
        # protonvpn-gui
        mpv

        # Editor
        unstable.neovim-qt

        # Misc utils
        xorg.xkill
        # iodine
        # networkmanager-iodine
        stable.tsocks
        # mitmproxy
        pavucontrol
        distrobox
        # unstable.posting
      ]
    )
  );

  linuxX64WorkstationPackages = (
    optionals isLinuxX64 (
      with pkgs;
      [
        # Mail
        (big protonmail-desktop)
        (big (
          unstable.mailspring.overrideAttrs (old: {
            postFixup = ''
              substituteInPlace $out/share/applications/Mailspring.desktop \
                --replace-fail Exec=mailspring "Exec=$out/bin/mailspring --password-store=\"kwallet5\""
            '';
          })
        ))

        (big google-chrome)
        unstable.discord
        (big jellyfin-desktop)
        # (big slack)
        # (big renderdoc)
        (big spotify)
        # (big teamspeak3)
        (big teamspeak6-client)
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
    unstable.neovide
    # unstable.imhex

    # Gaming
    moonlight-qt
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
      delta

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
      ffmpeg
      toilet

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
    ++ [ inputs.detectcharset.packages."${pkgs.stdenv.hostPlatform.system}".default ]
    ++ (optionals isX64 [
      # (big (asmrepl.override { bundlerApp = bundlerApp.override { ruby = ruby_3_2; }; }))
    ]);

in
{
  workstationPackages = builtins.filter (pkg: pkg != null) (
    linuxWorkstationPackages
    ++ linuxX64WorkstationPackages
    ++ darwinWorkstationPackages
    ++ commonWorkstationPackages
  );

  commonPackages = builtins.filter (pkg: pkg != null) (
    linuxCommonPkgs ++ darwinCommonPkgs ++ commonCommonPkgs
  );
}
