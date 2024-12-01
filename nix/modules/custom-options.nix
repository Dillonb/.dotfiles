{ pkgs, lib, ... }:
{
  options.dgbCustom = {
    alacritty = {

      fontSize = lib.mkOption {
        type = with pkgs.lib; types.int;
        default = 14;
        description = "The font size for Alacritty";
      };

      fontFamily = lib.mkOption {
        type = with pkgs.lib; types.str;
        default = "CaskaydiaMono Nerd Font";
        description = "The font family for Alacritty";
      };

    };
  };
}
