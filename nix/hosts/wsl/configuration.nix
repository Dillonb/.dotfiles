{ ... }:

{
  system.stateVersion = "24.05"; # Did you read the comment?

  wsl.wslConf.network.generateResolvConf = false;
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    "8.8.4.4"
  ];
}
