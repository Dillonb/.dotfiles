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
    nixpkgs-config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
    nixos = { hostname, system, role, modules, extra ? {} }:
      let
        overlay-unstable = final: prev: {
            unstable = import nixpkgs-unstable {
              system = system;
              config = nixpkgs-config;
            };
        };

        overlay-master = final: prev: {
            master = import nixpkgs-master {
              system = system;
              config = nixpkgs-config;
            };
        };
        overlays = ({ config, pkgs, ... }: {
          nixpkgs.overlays = [ overlay-unstable overlay-master ];
          nixpkgs.config = nixpkgs-config;
        });
        role-modules = {
          workstation = [
            ./workstation.nix
            ./modules/pipewire.nix
            ./modules/bluetooth.nix
          ];
        };
      in nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          {
            networking.hostName = hostname;
          }
          ./hosts/${hostname}.nix
          home-manager.nixosModules.home-manager
          overlays
        ] ++ modules 
          ++ role-modules.${role};
      };
  in
  {
    nixosConfigurations = {
      battlestation = nixos {
        hostname = "battlestation";
        role = "workstation";
        system = "x86_64-linux";
        modules = [
          ./modules/sunshine.nix
        ];
      };

      mini = nixos {
        hostname = "mini";
        system = "x86_64-linux";
        role = "workstation";
        modules = [
          nixos-hardware.nixosModules.dell-xps-13-9300
        ];
      };
    };
  };
}
