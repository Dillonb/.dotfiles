{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm = {
  #   enable = true;
  #   theme = "catppuccin-mocha";
  #   settings.General.InputMethod = ""; # Stop onscreen keyboard from showing up
  # };
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [ catppuccin-sddm ];

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    xkb.options = "caps:ctrl_modifier"; # Caps lock is also control
  };
  console.useXkbConfig = true; # Use xserver keyboard settings in virtual terminals

  # programs.kde-pim.kmail = true;
}
