{
  lib,
  pkgs,
  ...
}:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # This causes problems on osx, so only enable it elsewhere
      auto-optimise-store = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) true;

      substituters = [
        "https://attic.dgb.sh/system"
        "https://nix-community.cachix.org"
        "https://n64-tools.cachix.org"
      ];

      trusted-public-keys = [
        "system:E5ubGe/xsSF5nf2gxvZBP4WSVVFWis3lo+3A3HERoxc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "n64-tools.cachix.org-1:LsRfMtKGDYgYXKLOJOPz7ktRups5k+X2LxbGzVX3K6A="
      ];
    };
    package = pkgs.nix;
  };
}
