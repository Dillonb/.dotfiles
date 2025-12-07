{ ... }:
{
  imports = [
    ./pi4/configuration.nix
    ./pi4/hdmi_cec.nix
    ./pi4/hardware_configuration.nix
    ./pi4/ble_scale.nix
  ];
}
