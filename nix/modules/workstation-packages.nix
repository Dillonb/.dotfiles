{
  pkgs,
  inputs,
  config,
  ...
}:
let
  packages = import ./packages.nix {
    pkgs = pkgs;
    inputs = inputs;
    config = config;
  };
  workstationPackages = packages.workstationPackages;
in
{
  environment.systemPackages = workstationPackages;
}
