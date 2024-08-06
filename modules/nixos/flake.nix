{
  description = "Dillon's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    agenix.url = "github:ryantm/agenix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ts3status.url = "github:Dillonb/ts3status";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, nixos-hardware, home-manager, agenix, ts3status, ... }@inputs:
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

        overlay-missing-modules-okay = (final: super: {
             makeModulesClosure = x:
             super.makeModulesClosure (x // { allowMissing = true; });
             });

        overlays = ({ config, pkgs, ... }: {
          nixpkgs.overlays = [ overlay-unstable overlay-master overlay-missing-modules-okay ];
          nixpkgs.config = nixpkgs-config;
        });
        role-modules = {
          workstation = [
            ./common.nix
            ./workstation.nix
            ./modules/pipewire.nix
            ./modules/bluetooth.nix
            ./modules/custom-options.nix
            ./modules/flatpak-support.nix
            ./modules/ime.nix
            ./modules/kde.nix
            ./modules/home-manager.nix
            ./modules/workstation-packages.nix
            ./modules/common-packages.nix
            ./modules/appimage-support.nix
            ./modules/libreoffice.nix
          ];
          server = [
            ./common.nix
            ./modules/server-packages.nix
            ./modules/common-packages.nix
          ];
        };
      in nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs; };
        modules = [
          {
            networking.hostName = hostname;
            environment.systemPackages = [ agenix.packages.${system}.default ];
          }
          ./hosts/${hostname}.nix
          home-manager.nixosModules.home-manager
          overlays
          agenix.nixosModules.default
          ./secrets/load-secrets.nix
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
          ./modules/restic.nix
          ./modules/syncthing.nix
        ];
      };

      mini = nixos {
        hostname = "mini";
        system = "x86_64-linux";
        role = "workstation";
        modules = [
          nixos-hardware.nixosModules.dell-xps-13-9300
          ./modules/syncthing.nix
          ./modules/ssd.nix
        ];
      };

      teamspeak-server = nixos {
        hostname = "teamspeak-server";
        system = "x86_64-linux";
        role = "server";
        modules = [
          ./modules/restic.nix
          ./modules/ts3status.nix
          ./modules/syncthing.nix
          ./modules/netdata.nix
        ];
      };

      dulu = nixos {
        hostname = "dulu";
        system = "x86_64-linux";
        role = "server";
        modules = [
          ./modules/syncthing.nix
          ./modules/restic.nix
          ./modules/netdata.nix
        ];
      };

      pi4 = nixos {
        hostname = "pi4";
        system = "aarch64-linux";
        role = "server";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
      };
    };
  };
}
