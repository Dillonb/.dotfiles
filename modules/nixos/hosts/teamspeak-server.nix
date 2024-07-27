{ modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/azure-common.nix" ];

  services.openssh.settings.PasswordAuthentication = false;
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05";
}
