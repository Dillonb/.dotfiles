{
  description = "Dillon's NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/nixos-WSL/main";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    ts3status.url = "github:Dillonb/ts3status";
    ble-scale.url = "github:Dillonb/ble-scale";
    detectcharset.url = "github:Dillonb/detectcharset";
    pwndbg.url = "github:pwndbg/pwndbg/2025.05.30";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, nixos-hardware, home-manager-stable, home-manager-unstable, agenix, nixos-wsl, darwin, pwndbg, ... }@inputs:
    let
      nixpkgs-config-base = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
        permittedInsecurePackages = [
          "aspnetcore-runtime-wrapped-6.0.36"
          "aspnetcore-runtime-6.0.36"
          "dotnet-sdk-wrapped-6.0.428"
          "dotnet-sdk-6.0.428"
        ];
      };
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = f: nixpkgs-stable.lib.genAttrs systems (system: f {
        pkgs = import nixpkgs-stable { inherit system; };
      });
      mac = { hostname, system, modules }:
        let
          nixpkgs-config = nixpkgs-config-base;
          overlay-stable = final: prev: {
            stable = import nixpkgs-stable {
              system = system;
              config = nixpkgs-config;
            };
          };
          overlay-unstable = final: prev: {
            unstable = import nixpkgs-unstable {
              system = system;
              config = nixpkgs-config;
            };
          };
          overlays = ({ ... }: {
            nixpkgs.overlays = [ overlay-unstable overlay-stable ];
            nixpkgs.config = nixpkgs-config;
          });
        in
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = modules ++ [
            ./nix/hosts/${hostname}.nix
            ./nix/modules/osx.nix
            ./nix/modules/common-packages.nix
            ./nix/modules/workstation-packages.nix
            ./nix/modules/custom-options.nix
            overlays
          ];
        };
      nixos = { hostname, system, role, modules, channel ? "stable", cuda ? false }:
        let
          nixpkgs-config = nixpkgs-config-base // { cudaSupport = cuda; };
          nixpkgs-config-no-cuda = nixpkgs-config-base // { cudaSupport = false; };

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

          overlay-no-cuda = final: prev: {
            no-cuda = import nixpkgs {
              system = system;
              config = nixpkgs-config-no-cuda;
            };
          };

          overlay-stable = final: prev: {
            stable = import nixpkgs-stable {
              system = system;
              config = nixpkgs-config;
            };
          };

          overlay-unstable = final: prev: {
            unstable = import nixpkgs-unstable {
              system = system;
              config = nixpkgs-config;
            };
          };

          overlay-missing-modules-okay = (final: super: {
            makeModulesClosure = x:
              super.makeModulesClosure (x // { allowMissing = true; });
          });

          overlays = ({ ... }: {
            nixpkgs.overlays = [ overlay-stable overlay-unstable overlay-missing-modules-okay overlay-no-cuda ];
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
              ./nix/modules/fonts.nix
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
            ] ++ agenix-modules;

            server = [
              ./nix/common.nix
              ./nix/modules/custom-options.nix
              ./nix/modules/server-packages.nix
              ./nix/modules/common-packages.nix
            ] ++ agenix-modules;

            wsl = [
              ./nix/common.nix
              ./nix/modules/custom-options.nix
              ./nix/modules/common-packages.nix
              ./nix/modules/wsl-packages.nix
              nixos-wsl.nixosModules.wsl
              {
                wsl.enable = true;
                wsl.defaultUser = "dillon";
              }
            ];
          };
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
          cuda = true;
          modules = [
            ./nix/modules/libreoffice.nix
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
            ./nix/modules/libreoffice.nix
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
            ./nix/modules/netdata.nix
            ./nix/modules/my-wifi.nix
          ];
        };

        pbp = nixos {
          hostname = "pbp";
          system = "aarch64-linux";
          role = "workstation";
          channel = "unstable";
          modules = [
            nixos-hardware.nixosModules.pine64-pinebook-pro
          ];
        };

        dgbsp7 = nixos {
          hostname = "dgbsp7";
          system = "x86_64-linux";
          role = "workstation";
          channel = "unstable";
          modules = [
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            ./nix/modules/ssd.nix
          ];
        };

        dgbmbp-nixos-vm = nixos {
          hostname = "dgbmbp-nixos-vm";
          system = "aarch64-linux";
          role = "workstation";
          channel = "unstable";
          modules = [
          ];
        };

        wsl = nixos {
          hostname = "wsl";
          system = "x86_64-linux";
          role = "wsl";
          channel = "unstable";
          modules = [ ];
        };
      };

      darwinConfigurations = {
        dgbmbp = mac {
          hostname = "dgbmbp";
          system = "aarch64-darwin";
          modules = [
            ./nix/modules/fonts.nix
            home-manager-unstable.darwinModules.home-manager
            ./nix/modules/home-manager.nix
            {
              users.users.dillon = {
                name = "dillon";
                home = "/Users/dillon";
              };
              dgbCustom.alacritty.fontSize = 18;
            }
          ];
        };

        dgb-workmbp = mac {
          hostname = "dgb-workmbp";
          system = "aarch64-darwin";
          modules = [
            ./nix/modules/fonts.nix
            home-manager-unstable.darwinModules.home-manager
            ./nix/modules/home-manager.nix
            {
              dgbCustom.username = "dbeliveau";
              dgbCustom.alacritty.fontSize = 18;
              users.users.dbeliveau = {
                name = "dbeliveau";
                home = "/Users/dbeliveau";
              };
            }
          ];
        };
      };

      packages = forEachSystem ({ pkgs }: {
        all-nixos-systems = pkgs.stdenv.mkDerivation {
          name = "all-nixos-systems.json";
          phases = [ "installPhase" "fixupPhase" ];
          installPhase =
            let
              systems = builtins.attrNames self.nixosConfigurations;
            in
            ''
              echo '${builtins.toJSON systems}' > $out
            '';
        };
      });

      devShells = forEachSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            git
            vim
            zsh
            wget
            nh
            chezmoi
          ];
          shellHook = ''
            export FLAKE="`readlink -f ~/.dotfiles`"
          '';
        };
      });
    };
}
