{ pkgs, lib, ... }:
{
  options.dgbCustom = {
    username = lib.mkOption {
      type = with pkgs.lib; types.str;
      default = "dillon";
      description = "My username";
    };

    enableGaming = lib.mkOption {
      type = with pkgs.lib; types.bool;
      default = true;
      description = "Enable gaming";
    };

    minimal = lib.mkOption {
      type = with pkgs.lib; types.bool;
      default = false;
      description = "Don't install heavier packages";
    };

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
