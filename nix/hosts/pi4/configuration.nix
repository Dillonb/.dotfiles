{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  nix.settings.trusted-users = [ "dillon" ];
  system.stateVersion = "24.05";

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
    };
  };

  dgbCustom.minimal = true;
}
