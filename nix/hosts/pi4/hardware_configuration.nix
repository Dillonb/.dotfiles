{ pkgs, ... }:
{
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  # Audio
  boot.kernelParams = [
    "snd_bcm2835.enable_hdmi=1"
    "snd_bcm2835.enable_headphones=1"
  ];
  # TODO: figure out how to do this (device tree overlay?)
  # boot.loader.raspberryPi.firmwareConfig = ''
  #   dtparam=audio=on
  # '';

  hardware = {
    raspberry-pi."4" = {
      # audio.enable = true;
      bluetooth.enable = true;
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
    };
    deviceTree = {
      enable = true;
    };
  };
  console.enable = true;

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };
}
