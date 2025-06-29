{ pkgs, inputs, ... }:
let
  nixGLPkgs = inputs.nixGL.packages.x86_64-linux;
in
{
  home.username = "deck";
  home.homeDirectory = "/home/deck";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    alacritty
    nh
    ghostty
    nixGLPkgs.nixGLIntel
    nixGLPkgs.nixVulkanIntel
    nerd-fonts.caskaydia-mono
  ];
}
