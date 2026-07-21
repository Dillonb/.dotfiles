{
  description = "Dillon's NixOS configuration";

  inputs = {
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixos-stable";
        darwin.follows = "darwin";
        home-manager.follows = "home-manager-stable";
      };
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/nixos-WSL/main";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    ts3status = {
      url = "github:Dillonb/ts3status-rs";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    ble-scale = {
      url = "github:Dillonb/ble-scale";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    detectcharset = {
      url = "github:Dillonb/detectcharset";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    pwndbg = {
      url = "github:pwndbg/pwndbg/2026.02.18";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    copyparty = {
      url = "github:9001/copyparty/v1.20.18";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
  };

  outputs =
    {
      self,
      nixos-stable,
      nixos-unstable,
      nixos-hardware,
      home-manager-stable,
      home-manager-unstable,
      agenix,
      nixos-wsl,
      darwin,
      copyparty,
      ...
    }@inputs:
    let
      nixpkgs-config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
        permittedInsecurePackages = [
          # "aspnetcore-runtime-wrapped-6.0.36"
          # "aspnetcore-runtime-6.0.36"
          # "dotnet-sdk-wrapped-6.0.428"
          # "dotnet-sdk-6.0.428"
          # "qtwebengine-5.15.19"
        ];
      };
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem =
        f:
        nixos-stable.lib.genAttrs systems (system: f { pkgs = import nixos-stable { inherit system; }; });
      mac =
        {
          hostname,
          system,
          modules,
        }:
        let
          overlay-stable = final: prev: {
            stable = import nixos-stable {
              system = system;
              config = nixpkgs-config;
            };
          };
          overlay-unstable = final: prev: {
            unstable = import nixos-unstable {
              system = system;
              config = nixpkgs-config;
            };
          };
          overlays = (
            { ... }: {
              nixpkgs.overlays = [
                overlay-unstable
                overlay-stable
              ];
              nixpkgs.config = nixpkgs-config;
            }
          );
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
      nixos =
        {
          hostname,
          system,
          role,
          modules,
          channel ? "stable",
        }:
        let
          nixpkgs-config-cuda = nixpkgs-config // {
            cudaSupport = true;
          };

          nixpkgs-by-channel = {
            stable = nixos-stable;
            unstable = nixos-unstable;
          };

          home-manager-by-channel = {
            stable = home-manager-stable;
            unstable = home-manager-unstable;
          };

          nixpkgs = nixpkgs-by-channel."${channel}";
          home-manager = home-manager-by-channel."${channel}";

          overlay-cuda = final: prev: {
            cuda = import nixpkgs {
              system = system;
              config = nixpkgs-config-cuda;
            };
          };

          overlay-stable = final: prev: {
            stable = import nixos-stable {
              system = system;
              config = nixpkgs-config;
            };
          };

          # New check added in https://github.com/NixOS/nixpkgs/pull/532778
          # breaks cheetah3 for now - override it until there's a real fix in
          overlay-cheetah3 = final: prev: {
            pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
              (python-final: python-prev: {
                cheetah3 =
                  assert prev.lib.assertMsg (
                    python-prev.cheetah3.pname == "cheetah3"
                  ) "Nixpkgs fixed cheetah3; remove overlay-cheetah3 from flake.nix";
                  python-prev.cheetah3.overridePythonAttrs (_: {
                    pname = "ct3";
                  });
              })
            ];
          };

          overlay-unstable = final: prev: {
            unstable = import nixos-unstable {
              system = system;
              config = nixpkgs-config;
              overlays = [ overlay-cheetah3 ];
            };
          };

          overlay-missing-modules-okay = (
            final: super: { makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; }); }
          );

          overlays = (
            { ... }: {
              nixpkgs.overlays = [
                overlay-cheetah3
                overlay-stable
                overlay-unstable
                overlay-missing-modules-okay
                overlay-cuda
                copyparty.overlays.default
              ];
              nixpkgs.config = nixpkgs-config;
            }
          );
          agenix-modules = [
            agenix.nixosModules.default
            ./nix/secrets/load-secrets.nix
            { environment.systemPackages = [ agenix.packages.${system}.default ]; }
          ];
          role-modules = {
            workstation = [
              ./nix/common.nix
              ./nix/nix-settings.nix
              ./nix/workstation.nix
              ./nix/modules/fonts.nix
              ./nix/modules/pipewire.nix
              ./nix/modules/bluetooth.nix
              ./nix/modules/custom-options.nix
              ./nix/modules/flatpak-support.nix
              # ./nix/modules/ime.nix
              ./nix/modules/kde.nix
              # ./nix/modules/gnome.nix
              ./nix/modules/home-manager.nix
              ./nix/modules/workstation-packages.nix
              ./nix/modules/common-packages.nix
              # broken on aarch64 as of 2025-12-11
              # ./nix/modules/appimage-support.nix
            ]
            ++ agenix-modules;

            server = [
              ./nix/common.nix
              ./nix/nix-settings.nix
              ./nix/modules/custom-options.nix
              ./nix/modules/server-packages.nix
              ./nix/modules/common-packages.nix
            ]
            ++ agenix-modules;

            wsl = [
              ./nix/common.nix
              ./nix/nix-settings.nix
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
            { networking.hostName = hostname; }
            ./nix/hosts/${hostname}.nix
            home-manager.nixosModules.home-manager
            overlays
            copyparty.nixosModules.default
          ]
          ++ modules
          ++ role-modules.${role};
        };
      home =
        {
          hostname,
          system,
          modules,
        }:
        let
          overlay-stable = final: prev: {
            stable = import nixos-stable {
              system = system;
              config = nixpkgs-config;
            };
          };
          overlay-unstable = final: prev: {
            unstable = import nixos-unstable {
              system = system;
              config = nixpkgs-config;
            };
          };
          overlays = (
            { ... }: {
              nixpkgs.overlays = [
                overlay-stable
                overlay-unstable
                copyparty.overlays.default
              ];
              nixpkgs.config = nixpkgs-config;
            }
          );
        in
        home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = import nixos-unstable { inherit system; };
          extraSpecialArgs = { inherit inputs; };
          modules = [
            overlays
            ./nix/nix-settings.nix
            ./nix/hosts/${hostname}.nix
            ./nix/modules/custom-options.nix
            # ./nix/modules/home-manager.nix
          ]
          ++ modules;
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
            # ./nix/modules/libreoffice.nix
            ./nix/modules/sunshine.nix
            ./nix/modules/restic.nix
            ./nix/modules/syncthing.nix
            ./nix/modules/ssd.nix

            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-cpu-amd-zenpower
            nixos-hardware.nixosModules.common-pc-ssd
          ];
        };

        # mini = nixos {
        #   hostname = "mini";
        #   system = "x86_64-linux";
        #   role = "workstation";
        #   channel = "unstable";
        #   modules = [
        #     nixos-hardware.nixosModules.dell-xps-13-9300
        #     ./nix/modules/libreoffice.nix
        #     ./nix/modules/syncthing.nix
        #     ./nix/modules/ssd.nix
        #   ];
        # };

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
            ./nix/modules/nixos-unstable-watcher.nix
          ];
        };

        pi4 =
          let
            overlay-libcec-with-libraspberrypi = (
              self: super: { libcec = super.libcec.override { withLibraspberrypi = true; }; }
            );
          in
          nixos {
            hostname = "pi4";
            system = "aarch64-linux";
            role = "server";
            modules = [
              { nixpkgs.overlays = [ overlay-libcec-with-libraspberrypi ]; }
              nixos-hardware.nixosModules.raspberry-pi-4
              ./nix/modules/bluetooth.nix
              ./nix/modules/syncthing.nix
              ./nix/modules/netdata.nix
              ./nix/modules/my-wifi.nix
            ];
          };

        # pbp = nixos {
        #   hostname = "pbp";
        #   system = "aarch64-linux";
        #   role = "workstation";
        #   channel = "unstable";
        #   modules = [ nixos-hardware.nixosModules.pine64-pinebook-pro ];
        # };

        dgbmbp-nixos-vm = nixos {
          hostname = "dgbmbp-nixos-vm";
          system = "aarch64-linux";
          role = "workstation";
          channel = "unstable";
          modules = [ ];
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
            }
          ];
        };
      };

      homeConfigurations = {
        deck = home {
          hostname = "steamdeck";
          system = "x86_64-linux";
          modules = [ ];
        };
      };

      devShells = forEachSystem (
        { pkgs }: {
          default = pkgs.mkShell {
            packages = with pkgs; [
              bashInteractive
              attic-client
              git
              neovim
              zsh
              wget
              nh
              chezmoi
              nix
              nix-prefetch
              curl
              jq
              actionlint
            ];
            shellHook = ''
              export FLAKE="`readlink -f ~/.dotfiles`"
            '';
          };
        }
      );
      github-actions-matrix =
        let
          runner-arm64-linux = "ubuntu-24.04-arm";
          runner-x64-linux = "ubuntu-latest";
          runner-macos = "macos-latest";
          runnerFor =
            system:
            if system == "aarch64-linux" then
              runner-arm64-linux
            else if system == "x86_64-linux" then
              runner-x64-linux
            else
              runner-macos;
          nixos = map (
            name:
            let
              c = self.nixosConfigurations.${name};
            in
            {
              inherit name;
              target = ".#nixosConfigurations.${name}.config.system.build.toplevel";
              path = builtins.unsafeDiscardStringContext c.config.system.build.toplevel.outPath;
              runner = runnerFor c.config.nixpkgs.system;
            }
          ) (builtins.attrNames self.nixosConfigurations);
          darwin = map (
            name:
            let
              c = self.darwinConfigurations.${name};
            in
            {
              inherit name;
              target = ".#darwinConfigurations.${name}.system";
              path = builtins.unsafeDiscardStringContext c.system.outPath;
              runner = runnerFor c.config.nixpkgs.system;
            }
          ) (builtins.attrNames (self.darwinConfigurations or { }));
        in
        builtins.toJSON (nixos ++ darwin);
    };
}
