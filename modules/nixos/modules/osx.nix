{ pkgs, ... }:
{
  services.nix-daemon.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "dbeliveau" "dillon" ];
    };
  };

  programs = {
    direnv.enable = true;
  };

  security.pam.enableSudoTouchIdAuth = true;

  environment.systemPackages = with pkgs; [
    nh
  ];
}