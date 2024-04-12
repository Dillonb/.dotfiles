{lib, ...}:
{
  home-manager = {
    useGlobalPkgs = true;
    users.dillon = {pkgs, ...}: {
      home.stateVersion = "23.11";

      gtk = {
        enable = true;
        theme = {
          name = "Breeze-Dark";
          package = pkgs.libsForQt5.breeze-gtk;
        };
        cursorTheme = {
          name = "breeze_cursors";
          size = 24;
          package = pkgs.libsForQt5.breeze-gtk;
        };
        iconTheme = {
          name = "breeze-dark";
          package = pkgs.libsForQt5.breeze-gtk;
        };
        font = {
          name = "Noto Sans";
          size = 10;
          package = pkgs.noto-fonts;
        };
        gtk2.extraConfig =''
          gtk-enable-animations=1
          gtk-primary-button-warps-slider=0
          gtk-toolbar-style=3
          gtk-menu-images=1
          gtk-button-images=1
        '';
      };

      programs.alacritty = {
        enable = true;
        settings = {
          keyboard.bindings = [
            {
              key = "T";
              mods = "Control|Shift";
              action = "SpawnNewInstance"; 
            }
            {
              key = "N";
              mods = "Control|Shift";
              action = "SpawnNewInstance"; 
            }
          ];
          font.size = 12;
        };
      };

      systemd.user.services = {
        _1password = {
          Unit = {
            Description = "1password gui";
            Requires = "graphical-session.target";
            After = "graphical-session.target";
          };

          Install = {
            Alias = "1password.service";
            WantedBy = [ "graphical-session.target" ];
            Before = [ "spotifyd.service" ]; # Ensure 1password is running before spotifyd starts
          };

          Service = {
            ExecStart = "${lib.getExe pkgs._1password-gui} --silent";
            Type = "exec";
            Restart = "always";
          };
        };
      };

      services.spotifyd = {
        enable = true;
        settings.global = {
          bitrate = 320;
          username = "dillonbeliveau";
          password_cmd = "/home/dillon/.dotfiles/local/bin/get-spotify-password";
        };
      };
    };
  };
}