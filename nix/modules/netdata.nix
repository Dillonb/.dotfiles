{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Alert when systemd units fail
  unitTypes = [
    "service"
    "socket"
    "target"
    "path"
    "device"
    "mount"
    "automount"
    "swap"
    "scope"
    "slice"
    "timer"
  ];
  unitAlert = type: ''
        template: systemd_${type}_unit_failed_state
              on: systemd.${type}_unit_state
           class: Errors
            type: Linux
       component: Systemd units
    chart labels: unit_name=*
            calc: $failed
           units: state
           every: 10s
            warn: $this != nan AND $this == 1
           delay: down 5m multiplier 1.5 max 1h
         summary: systemd ${type} ''${label:unit_name} failed
            info: systemd ${type} unit is in the failed state
              to: sysadmin
  '';
in
{
  users.users.netdata.extraGroups = [
    "agenix" # secrets access
  ];
  services.netdata = {
    enable = true;
    # Add -trimpath to netdata's Go build so it doesn't pin the Go toolchain (~216 MiB) into the closure.
    package = pkgs.netdata.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace packaging/cmake/Modules/NetdataGoTools.cmake \
          --replace-fail '"''${GO_EXECUTABLE}" build -buildvcs=false' \
                         '"''${GO_EXECUTABLE}" build -trimpath -buildvcs=false'
      '';
    });
    configDir = {
      "health_alarm_notify.conf" = config.age.secrets."netdata-discord.conf".path;
      "health.d/systemdunits.conf" = pkgs.writeText "systemdunits-health.conf" (
        lib.concatMapStringsSep "\n" unitAlert unitTypes
      );
    };
  };
}
