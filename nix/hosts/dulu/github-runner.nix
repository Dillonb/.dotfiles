{ config, pkgs, ... }:
{
  services.github-runners.dotfiles = {
    enable = true;
    name = "dulu-dotfiles-runner";
    tokenFile = config.age.secrets."dotfiles-github-actions-token".path;
    url = "https://github.com/Dillonb/.dotfiles";
    extraPackages = with pkgs; [
      toilet
      jq
    ];
  };
}
