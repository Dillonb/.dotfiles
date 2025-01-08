{ pkgs, ... }:
{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      configPackages = [
        # https://wiki.archlinux.org/title/PipeWire#Audio_cutting_out_when_multiple_streams_start_playing
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/50-alsa-config.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                {
                  node.name = "~alsa_output.*"
                }
              ]
              actions = {
                update-props = {
                  api.alsa.period-size = 1024
                  api.alsa.headroom    = 8192
                }
              }
            }
          ]
        '')
      ];
    };

  };
  environment.systemPackages = with pkgs; [
    easyeffects
    qpwgraph
  ];
}
