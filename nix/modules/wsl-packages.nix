{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Editor
    vim # no gvim compared to vim-full
  ];
}
