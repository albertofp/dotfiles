{
  description = "Alberto's NixOS + macOS (nix-darwin) configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
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
    # NOTE: hyprpaper is a NixOS-only input (Wayland/Hyprland). Nix fetches all
    # flake inputs unconditionally, but hyprpaper is only *evaluated* inside
    # nixosConfigurations — it is never referenced in darwinConfigurations.
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
      nix-darwin,
      agenix,
      zen-browser,
      hyprpaper,
      rust-overlay,
      ...
    }:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      rustOverlay = {
        nixpkgs.overlays = [ rust-overlay.overlays.default ];
      };
    in
    {
      # ── NixOS ────────────────────────────────────────────────────────────────
      #   sudo nixos-rebuild switch --flake .#alberto
      nixosConfigurations.alberto = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        modules = [
          ./nixos/system.nix
          rustOverlay
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alberto = import ./nixos/home.nix;
              extraSpecialArgs = {
                zen-browser-pkg = zen-browser.packages.${linuxSystem}.default;
                hyprpaper-pkg = hyprpaper.packages.${linuxSystem}.hyprpaper;
              };
            };

            # ── Secrets ─────────────────────────────────────────────────────
            age.secrets.shell-secrets = {
              file = ./secrets/shell-secrets.age;
              owner = "alberto";
              mode = "0400";
            };

            environment.systemPackages = [ agenix.packages.${linuxSystem}.default ];
          }
        ];
      };

      # ── macOS (nix-darwin) ───────────────────────────────────────────────────
      #   darwin-rebuild switch --flake .#alberto-mac
      darwinConfigurations.alberto-mac = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        modules = [
          ./darwin/system.nix
          rustOverlay
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              users.albertopluecker = import ./darwin/home.nix;
              extraSpecialArgs = {
                zen-browser-pkg = zen-browser.packages.${darwinSystem}.default;
              };
            };
          }
        ];
      };

      # ── Formatters ───────────────────────────────────────────────────────────
      formatter.${linuxSystem} = nixpkgs.legacyPackages.${linuxSystem}.nixfmt;
      formatter.${darwinSystem} = nixpkgs.legacyPackages.${darwinSystem}.nixfmt;
    };
}
