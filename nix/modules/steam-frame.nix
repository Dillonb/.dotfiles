# Steam Frame specific settings
{ pkgs, ... }:

{
  # The adapter's driver (rtw89_8852cu) needs Linux 7.2+
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Without a country the regdomain stays "00", which disables 6 GHz (needed by the adapter)
  boot.kernelParams = [ "cfg80211.ieee80211_regdom=US" ];

  # Wi-Fi power saving makes the adapter's streaming link less stable
  networking.networkmanager.wifi.powersave = false;
}
