{ pkgs, ... }: {
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;

      substituters = [
        "https://cache.nix.dgb.sh"
        "https://attic.dgb.sh/system"
        "https://nix-community.cachix.org"
        "https://n64-tools.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nix.dgb.sh:XzJS7VYoZ90T3fwKySBAqfKdxViX6zk2PJvlKVD+euU="
        "system:8wY144D+RiSnHTEn14pAI++9jPMPT34mXMYMzZPB/Jg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "n64-tools.cachix.org-1:LsRfMtKGDYgYXKLOJOPz7ktRups5k+X2LxbGzVX3K6A="
      ];
    };
    package = pkgs.nix;
  };
}
