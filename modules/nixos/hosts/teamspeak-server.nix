{ modulesPath, pkgs, ... }:

{
  imports = [ "${modulesPath}/virtualisation/azure-common.nix" ];

  users = {
    defaultUserShell = pkgs.zsh;
    users.dillon = {
      isNormalUser = true;
      description = "Dillon Beliveau";
      extraGroups = [ "wheel" ];
    };
  };
  nix.settings.trusted-users = [ "@wheel" ];

  # test user doesn't have a password
  services.openssh.settings.PasswordAuthentication = false;
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git file htop wget curl vim zsh
    unstable.neovim
  ];

  system.stateVersion = "24.05";
}
