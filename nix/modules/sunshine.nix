{ config, pkgs, ... }:

let sunshine = pkgs.sunshine.override { cudaSupport = true; };
in
{
  environment.systemPackages = [
    sunshine
  ];

  # Needed for KMS capture mode - unsure if needed for X11
  security.wrappers.sunshine = {
    owner = "dillon";
    group = "users";
    capabilities = "cap_sys_admin+p";
    source = "${sunshine}/bin/sunshine";
  };

  networking.firewall = {
    allowedTCPPorts = [ 47984 47989 47990 48010 ]; # Sunshine
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; } # Sunshine
    ];
  };

  systemd.user.services.sunshine = {
    description = "Self-hosted game stream host for Moonlight";

    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    startLimitIntervalSec = 500;
    startLimitBurst = 5;

    serviceConfig = {
      # only add configFile if an application or a setting other than the default port is set to allow configuration from web UI
      ExecStart = "${config.security.wrapperDir}/sunshine";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
