{
  description = "Dillon's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, nixos-hardware, home-manager, ... }@inputs:
  let
    system_x86_64_linux = "x86_64-linux";
    nixpkgs-config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
    overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = system_x86_64_linux;
          config = nixpkgs-config;
        };
    };

    overlay-master = final: prev: {
        master = import nixpkgs-master {
          system = system_x86_64_linux;
          config = nixpkgs-config;
        };
    };
    overlays = ({ config, pkgs, ... }: {
      nixpkgs.overlays = [ overlay-unstable overlay-master ];
      nixpkgs.config = nixpkgs-config;
    });
  in
  {
    nixosConfigurations = {
      battlestation = nixpkgs.lib.nixosSystem {
        system = system_x86_64_linux;
        modules = [

          ./hosts/battlestation.nix
          ./configuration.nix
          ./modules/pipewire.nix
          ./modules/sunshine.nix
          ./modules/bluetooth.nix


          overlays
          home-manager.nixosModules.home-manager
        ];
      };

      mini = nixpkgs.lib.nixosSystem {
        system = system_x86_64_linux;
        modules = [

          ./hosts/mini.nix
          ./configuration.nix
          ./modules/pipewire.nix
          ./modules/bluetooth.nix

          nixos-hardware.nixosModules.dell-xps-13-9300

          overlays
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
