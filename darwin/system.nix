{
  pkgs,
  config,
  darwinUser,
  darwinHome,
  ...
}:

{
  # ── User ────────────────────────────────────────────────────────────────────
  # Required for home-manager to resolve the home directory correctly.
  # primaryUser is required by nix-darwin for user-scoped options (homebrew,
  # system.defaults, etc.) now that all system activation runs as root.
  system.primaryUser = darwinUser;

  users.users.${darwinUser} = {
    name = darwinUser;
    home = darwinHome;
  };

  # ── macOS system defaults ────────────────────────────────────────────────────
  system = {
    # Increment when nix-darwin adds breaking changes
    stateVersion = 5;

    defaults = {
      NSGlobalDomain = {
        # Disable window open/close animations
        NSAutomaticWindowAnimationsEnabled = false;
        # Use fn key for media functions (not F-keys)
        "com.apple.keyboard.fnState" = true;
      };

      trackpad = {
        # Tap to click
        Clicking = true;
      };
    };

    activationScripts = {
      # Caps Lock → Escape (via hidutil, applied on activation)
      capsLockToEscape.text = ''
        hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}' > /dev/null
      '';

      # Default browser — zen browser (idempotent; macOS may still prompt once)
      defaultBrowser.text = ''
        ${pkgs.defaultbrowser}/bin/defaultbrowser zen 2>/dev/null || true
      '';
    };
  };

  # ── Homebrew — only for packages unavailable in nixpkgs ────────────────────
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap"; # remove casks no longer listed here
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "nikitabobko/tap/aerospace" # tiling WM — not in nixpkgs, custom tap
      "ghostty" # linux-only in nixpkgs
      "google-chrome" # browser — not well supported in nixpkgs on darwin
      "okta-verify" # Okta device trust — proprietary
      "anki" # not available for aarch64-darwin in nixpkgs
      "jellyfin-media-player" # desktop client — nix build has SSL issues on macOS
      "qobuz" # music streaming — not packaged
      "raycast" # launcher — proprietary, not in nixpkgs
      "runelite" # not in nixpkgs for aarch64-darwin
      "soulseek" # file sharing — not packaged for macOS
      "vlc" # linux-only in nixpkgs
      "whatsapp" # not packaged for macOS
    ];
  };

  # ── Nix settings ────────────────────────────────────────────────────────────
  # Determinate Nix manages its own daemon — disable nix-darwin's Nix management
  # to avoid conflicts. Nix settings are configured via Determinate instead.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  # Default shell
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    curl
    vim
  ];
}
