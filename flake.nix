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
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-aerospace = {
      url = "github:nikitabobko/homebrew-aerospace";
      flake = false;
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
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-aerospace,
      ...
    }:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      rustOverlay = {
        nixpkgs.overlays = [ rust-overlay.overlays.default ];
      };
      # Infer the macOS username from the environment at eval time.
      # Prefer SUDO_USER (set when invoked via sudo) so we get the real user
      # even when darwin-rebuild is run as root. Falls back to USER, then "admin".
      darwinUser =
        let
          sudoUser = builtins.getEnv "SUDO_USER";
          user = builtins.getEnv "USER";
        in
        if sudoUser != "" then
          sudoUser
        else if user != "" && user != "root" then
          user
        else
          "admin";
      darwinHome = "/Users/${darwinUser}";
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
        specialArgs = {
          inherit darwinUser darwinHome;
        };
        modules = [
          ./darwin/system.nix
          rustOverlay
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = darwinUser;
              autoMigrate = true;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "nikitabobko/homebrew-aerospace" = homebrew-aerospace;
              };
              mutableTaps = false;
            };
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              users.${darwinUser} = import ./darwin/home.nix;
              extraSpecialArgs = {
                inherit darwinUser darwinHome;
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
