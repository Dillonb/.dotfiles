{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnuradio
  ];
  system.stateVersion = 5;
}
