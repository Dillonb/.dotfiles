{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha";
    settings.General.InputMethod = ""; # Stop onscreen keyboard from showing up
  };
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    catppuccin-sddm
  ];

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    xkb.options = "caps:ctrl_modifier"; # Caps lock is also control
  };
  console.useXkbConfig = true; # Use xserver keyboard settings in virtual terminals

  programs.kde-pim.kmail = true;

  # Additional stylix config in home-manager.nix
  stylix = {
    enable = true;
    autoEnable = false; # Only enable what I explicitly enable
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/AngelJumbo/gruvbox-wallpapers/refs/heads/main/wallpapers/minimalistic/gruvbox_astro.jpg";
      sha256 = "sha256-YTxyI+vaC5CGQzqMm1enfPh9/1YoqNXAX7TmAscz1U0=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
  };
}
