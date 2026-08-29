{
  nixos-stable,
  nixos-unstable,
  nixpkgs-config,
}:
let
  overlay-stable = system: final: prev: {
    stable = import nixos-stable {
      inherit system;
      config = nixpkgs-config;
    };
  };

  overlay-unstable = system: final: prev: {
    unstable = import nixos-unstable {
      inherit system;
      config = nixpkgs-config;
    };
  };
in
{
  mkOverlaysModule =
    {
      system,
      extraOverlays ? [ ],
    }:
    { ... }:
    {
      nixpkgs.overlays = [
        (overlay-stable system)
        (overlay-unstable system)
      ]
      ++ extraOverlays;
      nixpkgs.config = nixpkgs-config;
    };
}
