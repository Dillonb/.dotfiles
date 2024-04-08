{
  # Allows processes to request realtime priority. Pulseaudio needs this.
  security.rtkit.enable = true;

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
  services.pipewire.enable = false;
}