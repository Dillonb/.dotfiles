{ ... }: {
  nix.settings.trusted-users = [ "dillon" ];
  system.stateVersion = "24.05";

  dgbCustom.minimal = true;
}
