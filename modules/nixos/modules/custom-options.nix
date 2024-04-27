{pkgs, lib, ...}:
{
  options.dgbCustom = {
    alacritty.fontSize = lib.mkOption {
      type = with pkgs.lib; types.int;
      default = 12;
      description = "The font size for alacritty";
    };
  };
}