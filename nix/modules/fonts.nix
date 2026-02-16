{ pkgs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  optionals = pkgs.lib.optionals;
  linuxFonts = optionals isLinux (
    with pkgs;
    [
      noto-fonts-color-emoji # don't need these on darwin
    ]
  );
in
{
  # Fix noto color emoji fonts not rendering in firefox
  fonts.fontconfig.useEmbeddedBitmaps = true;
  fonts.packages =
    with pkgs;
    [
      hasklig
      terminus_font
      dejavu_fonts
      hack-font
      noto-fonts-cjk-sans
      cascadia-code
      libertine
      # (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
      nerd-fonts.caskaydia-mono
    ]
    ++ linuxFonts;
}
