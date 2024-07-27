{ ... }:
{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  programs = {
    zsh.enable = true;
    nh.enable = true;
  };
}
