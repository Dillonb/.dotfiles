{
  lib,
  config,
  pkgs,
  ...
}:
let
  dgbCustom = config.dgbCustom;
in
{
  system.primaryUser = "${dgbCustom.username}";
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # This casues problems on osx
      # auto-optimise-store = true;
      trusted-users = [
        "dbeliveau"
        "dillon"
      ];
    };
  };

  programs = {
    direnv.enable = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  services.aerospace = {
    enable = true;
    settings = {
      gaps = {
        outer.left = 0;
        outer.bottom = 0;
        outer.top = 0;
        outer.right = 0;
      };
      mode.main.binding = {
        # Switch workspaces
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
        alt-0 = "workspace 10";

        # Change focus
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # Move windows between workspaces
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
        alt-shift-0 = "move-node-to-workspace 10";

        # Consider using 'join-with' command as a 'split' replacement if you want to enable
        # normalizations
        # alt-h = "split horizontal";
        # alt-v = "split vertical";

        alt-f = "fullscreen";

        alt-s = "layout v_accordion"; # 'layout stacking' in i3
        alt-w = "layout h_accordion"; # 'layout tabbed' in i3
        alt-e = "layout tiles horizontal vertical"; # 'layout toggle split' in i3

        alt-shift-space = "layout floating tiling"; # 'floating toggle' in i3

        alt-r = "mode resize";
      };



      mode.resize.binding = {
        h = "resize width -50";
        j = "resize height +50";
        k = "resize height -50";
        l = "resize width +50";
        enter = "mode main";
        esc = "mode main";
      };
    };
  };

  environment.systemPackages = with pkgs; [ nh ];

  system.activationScripts.applications.text =
    lib.mkForce # sh
      ''
        # Set up applications.
            echo "setting up /Applications/Nix Apps..." >&2

            nix_apps='/Applications/Nix Apps'
            rm -rf "$nix_apps"
            mkdir -p "$nix_apps"

            find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read -r app; do
            appname="$(basename "$app")"
            mkdir "$nix_apps/$appname"
            ln -s "$app/Contents" "$nix_apps/$appname/Contents"
            done
      '';
}
