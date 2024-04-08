{
  # Allows processes to request realtime priority. Pulseaudio needs this.
  security.rtkit.enable = true;

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    # Stop Discord/TeamSpeak from muting other applications
    extraConfig = "unload-module module-role-cork";
  };
  services.pipewire.enable = false;
}