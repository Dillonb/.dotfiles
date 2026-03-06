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

    miniflux.port = lib.mkOption {
      type = with pkgs.lib; types.port;
      default = 8080;
      description = "The port on which Miniflux will run.";
    };
  };
}
