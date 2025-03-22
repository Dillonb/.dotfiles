{ config, ... }:
{
  services.github-runners.dotfiles = {
    enable = true;
    name = "dulu-dotfiles-runner";
    tokenFile = config.age.secrets."dotfiles-github-actions-token".path;
    url = "https://github.com/Dillonb/.dotfiles";
  };
}
