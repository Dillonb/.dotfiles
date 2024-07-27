{ modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/azure-common.nix" ];

  services.openssh.settings.PasswordAuthentication = false;

  system.stateVersion = "24.05";
}
