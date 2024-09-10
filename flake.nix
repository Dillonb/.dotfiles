{
  description = "Dillon's NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    agenix.url = "github:ryantm/agenix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/nixos-WSL/main";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    ts3status.url = "github:Dillonb/ts3status";
    ble-scale.url = "github:Dillonb/ble-scale";
    detectcharset.url = "github:Dillonb/detectcharset";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, nixpkgs-master, nixos-hardware, home-manager-stable, home-manager-unstable, agenix, ts3status, nixos-wsl, darwin, ... }@inputs:
    let
      nixpkgs-config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = f: nixpkgs-stable.lib.genAttrs systems (system: f {
        pkgs = import nixpkgs-stable { inherit system; };
      });
      mac = { hostname, system, modules }:
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
        in
        darwin.lib.darwinSystem {
          inherit system;
          modules = modules ++ [
            ./nix/hosts/${hostname}.nix
            ./nix/modules/osx.nix
            ./nix/modules/common-packages.nix
            overlays
          ];
        };
      nixos = { hostname, system, role, modules, channel ? "stable", extra ? { } }:
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
          agenix-modules = [
            agenix.nixosModules.default
            ./nix/secrets/load-secrets.nix
            {
              environment.systemPackages = [ agenix.packages.${system}.default ];
            }
          ];
          role-modules = {
            workstation = [
              ./nix/common.nix
              ./nix/workstation.nix
              ./nix/modules/pipewire.nix
              ./nix/modules/bluetooth.nix
              ./nix/modules/custom-options.nix
              ./nix/modules/flatpak-support.nix
              # ./nix/modules/ime.nix
              ./nix/modules/kde.nix
              ./nix/modules/home-manager.nix
              ./nix/modules/workstation-packages.nix
              ./nix/modules/common-packages.nix
              ./nix/modules/appimage-support.nix
              ./nix/modules/libreoffice.nix
            ] ++ agenix-modules;

            server = [
              ./nix/common.nix
              ./nix/modules/server-packages.nix
              ./nix/modules/common-packages.nix
            ] ++ agenix-modules;

            wsl = [
              ./nix/common.nix
              ./nix/modules/common-packages.nix
              ./nix/modules/wsl-packages.nix
              nixos-wsl.nixosModules.wsl
              {
                wsl.enable = true;
                wsl.defaultUser = "dillon";
              }
            ];
          };


          nixpkgs-by-channel = {
            stable = nixpkgs-stable;
            unstable = nixpkgs-unstable;
          };

          home-manager-by-channel = {
            stable = home-manager-stable;
            unstable = home-manager-unstable;
          };

          nixpkgs = nixpkgs-by-channel."${channel}";
          home-manager = home-manager-by-channel."${channel}";
        in
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = { inherit inputs; };
          modules = [
            {
              networking.hostName = hostname;
            }
            ./nix/hosts/${hostname}.nix
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
          channel = "unstable";
          system = "x86_64-linux";
          modules = [
            ./nix/modules/sunshine.nix
            ./nix/modules/restic.nix
            ./nix/modules/syncthing.nix
            ./nix/modules/ssd.nix
          ];
        };

        mini = nixos {
          hostname = "mini";
          system = "x86_64-linux";
          role = "workstation";
          channel = "unstable";
          modules = [
            nixos-hardware.nixosModules.dell-xps-13-9300
            ./nix/modules/syncthing.nix
            ./nix/modules/ssd.nix
          ];
        };

        teamspeak-server = nixos {
          hostname = "teamspeak-server";
          system = "x86_64-linux";
          role = "server";
          modules = [
            ./nix/modules/restic.nix
            ./nix/modules/ts3status.nix
            ./nix/modules/syncthing.nix
            ./nix/modules/netdata.nix
          ];
        };

        dulu = nixos {
          hostname = "dulu";
          system = "x86_64-linux";
          role = "server";
          modules = [
            ./nix/modules/syncthing.nix
            ./nix/modules/restic.nix
            ./nix/modules/netdata.nix
            ./nix/modules/ssd.nix
          ];
        };

        pi4 = nixos {
          hostname = "pi4";
          system = "aarch64-linux";
          role = "server";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./nix/modules/bluetooth.nix
            ./nix/modules/syncthing.nix
          ];
        };

        wsl = nixos {
          hostname = "wsl";
          system = "x86_64-linux";
          role = "wsl";
          modules = [ ];
        };
      };

      darwinConfigurations = {
        dgbmbp = mac {
          hostname = "dgbmbp";
          system = "aarch64-darwin";
          modules = [ ];
        };
      };

      devShells = forEachSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            git
            vim
            zsh
            wget
            nh
          ];
          shellHook = ''
            export FLAKE="`readlink -f ~/.dotfiles`"
          '';
        };
      });
    };
}
