{ pkgs, ... }:
let
  kodiUser = "kodi";
  # NOTE: pulling kodi from unstable won't work right now, the overlay defined in flake.nix to add raspberry pi support
  # to libcec is not applied to pkgs from nixpkgs-unstable. CEC will not work without that.
  # TODO: If I ever need to update kodi beyond what's in stable, probably I'll just update the whole system to unstable

  kodiPackage = pkgs.kodi.withPackages (kodiPkgs: with kodiPkgs; [ jellyfin ]);
  # Wayland version (see below)
  # kodiPackage = pkgs.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [ jellyfin ]);
in
{
  users.extraUsers.${kodiUser} = {
    isNormalUser = true;
    extraGroups = [
      "video"
      "audio"
      "input"
      "render"
    ];
    shell = pkgs.bash;
  };

  # X server setup: working, but slow
  services.displayManager.autoLogin.user = kodiUser;
  services.xserver = {
    enable = true;
    desktopManager.kodi = {
      enable = true;
      package = kodiPackage;
    };
    displayManager.lightdm.greeter.enable = false;
  };

  # Wayland setup: supposedly faster, but doesn't work (kodi crashes)
  # services.cage.user = kodiUser;
  # services.cage.program = "${kodiPackage}/bin/kodi-standalone";
  # services.cage.enable = true;
}
