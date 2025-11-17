{
  pkgs,
  inputs,
  config,
  ...
}:
let
  nixGLPkgs = inputs.nixGL.packages.x86_64-linux;
  packages = import ../modules/packages.nix {
    pkgs = pkgs;
    inputs = inputs;
    config = config;
  };
in
{
  dgbCustom.minimal = true;
  home.username = "deck";
  home.homeDirectory = "/home/deck";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  programs.direnv.enable = true;

  fonts.fontconfig.enable = true;

  home.packages =
    with pkgs;
    [
      alacritty
      nh
      neovim
      ghostty
      chezmoi
      nil
      nixGLPkgs.nixGLIntel
      nixGLPkgs.nixVulkanIntel
      nerd-fonts.caskaydia-mono
    ]
    ++ packages.commonPackages
    ++ packages.workstationPackages;
}
