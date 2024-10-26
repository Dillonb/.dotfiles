{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    hasklig
    terminus_font
    dejavu_fonts
    hack-font
    noto-fonts-cjk-sans
    cascadia-code
    noto-fonts-color-emoji
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];
}
