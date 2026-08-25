{ pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;

  environment.systemPackages = with pkgs; [ kdePackages.kde-gtk-config ];

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    xkb.options = "caps:ctrl_modifier"; # Caps lock is also control
  };
  console.useXkbConfig = true; # Use xserver keyboard settings in virtual terminals

  # programs.kde-pim.kmail = true;
}
