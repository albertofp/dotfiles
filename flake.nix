{
  description = "Alberto's NixOS + home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      agenix,
      zen-browser,
      hyprpaper,
      rust-overlay,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      #   sudo nixos-rebuild switch --flake .#alberto
      nixosConfigurations.alberto = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/system.nix
          { nixpkgs.overlays = [ rust-overlay.overlays.default ]; }
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alberto = import ./nixos/home.nix;
              extraSpecialArgs = {
                zen-browser-pkg = zen-browser.packages.${system}.default;
                hyprpaper-pkg = hyprpaper.packages.${system}.hyprpaper;
              };
            };

            # ── Secrets ───────────────────────────────────────────────────────
            age.secrets.shell-secrets = {
              file = ./secrets/shell-secrets.age;
              owner = "alberto";
              mode = "0400";
            };

            environment.systemPackages = [ agenix.packages.${system}.default ];
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
