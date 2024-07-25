{config, lib, pkgs, ...}:
let
# timestamp = "${pkgs.runCommand "timestamp" { env.when = builtins.currentTime; } "echo -n `date -d @$when +%Y-%m-%d_%H-%M-%S` > $out"}";
dgbCustom = config.dgbCustom;
in
{
  home-manager = {
    useGlobalPkgs = true;
    # backupFileExtension = "home-manager-backup-${builtins.readFile timestamp}";
    backupFileExtension = "home-manager-backup";
    users.dillon = {pkgs, config, ...}: {
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
      };

      # Force home-manager to overwrite ~/.gtkrc-2.0 file
      home.file.${config.gtk.gtk2.configLocation}.force = true;

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
          font = {
            size = dgbCustom.alacritty.fontSize;
            normal = { family = dgbCustom.alacritty.fontFamily; style = "Regular"; };
            bold   = { family = dgbCustom.alacritty.fontFamily; style = "Bold"; };
            italic = { family = dgbCustom.alacritty.fontFamily; style = "Italic"; };
          };
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
          };

          Service = {
            ExecStart = "${lib.getExe pkgs._1password-gui} --silent";
            Type = "exec";
            Restart = "always";
          };
        };
      };
    };
  };
}
