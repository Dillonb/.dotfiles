{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable GNOME
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    xkb.options = "caps:ctrl_modifier"; # Caps lock is also control
  };
  console.useXkbConfig = true; # Use xserver keyboard settings in virtual terminals
  environment.systemPackages = with pkgs; [ gnome-tweaks ];
}
