{pkgs, ...}:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Should fix audio crackling issues
    # TODO: different values for desktop and laptop?
    extraConfig.pipewire."92-low-latency" = {
      context.properties.default.clock.min-quantum = 512;
    };

  };
  environment.systemPackages = with pkgs; [ easyeffects ];
}