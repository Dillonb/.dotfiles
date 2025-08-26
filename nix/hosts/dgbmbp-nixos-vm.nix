{ inputs, pkgs, ... }:
let
  pwndbg = inputs.pwndbg.packages."${pkgs.system}".default;
  # pwndbg-lldb = inputs.pwndbg.packages."${pkgs.system}".pwndbg-lldb;
in
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d5e9bfe4-c922-4dc0-bad9-b9a58b54bd6e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D23F-4093";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  environment.systemPackages = [
    pwndbg
    # pwndbg-lldb
  ];

  virtualisation.vmware.guest.enable = true;

  dgbCustom.minimal = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.11";
}
