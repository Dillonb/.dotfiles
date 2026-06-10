{ config, pkgs, ... }:
let
  webhookFile = config.age.secrets."nixos-unstable-discord-webhook".path;
  script = pkgs.writeShellApplication {
    name = "nixos-unstable-watcher";
    runtimeInputs = with pkgs; [
      curl
      jq
      coreutils
    ];
    text = ''
      state="$STATE_DIRECTORY/last-revision"
      new=$(curl -fsSL https://channels.nixos.org/nixos-unstable/git-revision)
      old=$(cat "$state" 2>/dev/null || true)
      [[ "$new" == "$old" ]] && { echo "no change ($new)"; exit 0; }

      if [[ -n "$old" ]]; then
        msg="\`nixos-unstable\` advanced: \`''${old:0:12}\` → \`''${new:0:12}\`"$'\n'"https://github.com/NixOS/nixpkgs/compare/$old...$new"
      else
        msg="\`nixos-unstable\` initial revision: \`''${new:0:12}\`"$'\n'"https://github.com/NixOS/nixpkgs/commit/$new"
      fi

      jq -nc --arg c "$msg" '{content:$c}' \
        | curl -fsSL -H 'Content-Type: application/json' -d @- "$(cat ${webhookFile})" > /dev/null

      printf '%s\n' "$new" > "$state"
    '';
  };
in
{
  systemd.services.nixos-unstable-watcher = {
    description = "Notify Discord when nixos-unstable advances";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.lib.getExe script;
      StateDirectory = "nixos-unstable-watcher";
    };
  };

  systemd.timers.nixos-unstable-watcher = {
    description = "Periodic nixos-unstable channel check";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2m";
      OnCalendar = "00/6:00:00";
      RandomizedDelaySec = "15m";
      Persistent = true;
    };
  };
}
