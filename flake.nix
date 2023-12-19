{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-input.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations.wbg-pc = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        { 
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.nixPath = [ "/etc/nix/path" ];
          environment.etc."nix/path/nixpkgs".source = nixpkgs;
        }
        ./nix-config/nix-config.nix
        ./nix-config/hardware.nix
        ./nix-config/software/core.nix
        ./nix-config/software/dev.nix
        ./nix-config/software/casual.nix
        ./nix-config/system-settings.nix
        ./nix-config/users.nix
        ./nix-config/env-variables.nix

        (import ./nix-config/hyprland.nix inputs system)

        ./nix-config/docker.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alphabril.imports = [
            ./nix-config/home/home.nix
            ./nix-config/home/ocr.nix
            ./nix-config/home/org.nix
          ];
        }
      ];
    };
  };
}
