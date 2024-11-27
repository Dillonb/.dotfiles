{ config, pkgs, ... }:

let
  lib = pkgs.lib;
  cudaPackages = pkgs.cudaPackages;
  sunshine = (pkgs.sunshine.override {
    cudaSupport = true;
    cudaPackages = cudaPackages;
    boost = pkgs.boost186;
  }).overrideAttrs (old: {
    version = "git";
    src = pkgs.fetchFromGitHub {
      owner = "LizardByte";
      repo = "Sunshine";
      rev = "fc5314b1b65f424865d3378a5ebdc0c25ccb2c49"; # 2024-11-03
      hash = "sha256-/1HeLe9ReVACS1JmvZM7SX5iW7aX09iMiCZlaZdPn2c=";
      fetchSubmodules = true;
    };
    patches = [ ];
    cmakeFlags = old.cmakeFlags ++ [
      "-DBOOST_USE_STATIC=Off"
      "-DCMAKE_CUDA_COMPILER=${(lib.getExe cudaPackages.cuda_nvcc)}"
    ];
    nativeBuildInputs =
      old.nativeBuildInputs
      ++ [
        cudaPackages.cuda_nvcc
        (lib.getDev cudaPackages.cuda_cudart)
        pkgs.nodejs
        pkgs.doxygen
        pkgs.graphviz
      ];
    buildInputs =
      old.buildInputs
      ++ [
        pkgs.libsysprof-capture
        pkgs.lerc
      ];
  });
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
