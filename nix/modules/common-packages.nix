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
  commonPackages = packages.commonPackages;
in
{
  environment.systemPackages = commonPackages;
}
