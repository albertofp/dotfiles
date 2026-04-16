{
  description = "Alberto's NixOS + home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs   = nixpkgs.legacyPackages.${system};
    in {
      # Full NixOS system — apply with:
      #   sudo nixos-rebuild switch --flake .#alberto
      nixosConfigurations.alberto = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./system.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;
            home-manager.users.alberto   = import ./home.nix;
          }
        ];
      };

      # Standalone home-manager — useful if you ever run NixOS with an
      # externally managed system config:
      #   nix run home-manager -- switch --flake .#alberto
      homeConfigurations.alberto = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
