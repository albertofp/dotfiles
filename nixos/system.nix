{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Required for NVIDIA + Wayland (Hyprland)
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
    # Load nvidia modules early so KMS is available before display manager starts
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };

  # ── Networking ────────────────────────────────────────────────────────────
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # Fallback DNS — avoids link-local IPv6 resolver failures in CLI tools
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    hosts = {
      # Add custom /etc/hosts entries here, e.g.:
      # "192.168.1.100" = [ "mydevice.local" ];
    };
  };

  # ── Locale / time ─────────────────────────────────────────────────────────
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Console / TTY keyboard ────────────────────────────────────────────────
  console.keyMap = "de";

  # ── NVIDIA ────────────────────────────────────────────────────────────────
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false; # Pascal (GTX 1080) — open module not supported
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };
    graphics.enable = true;
  };

  environment = {
    # Mesa 25.x loads nvidia-drm_gbm.so which crashes with legacy_535.
    # Override the GBM backend path to use only Mesa's own implementation.
    variables.GBM_BACKEND = "drm";
    # Hint Electron apps to use Wayland
    sessionVariables.NIXOS_OZONE_WL = "1";
    # ── System packages (minimal — user packages live in home.nix) ────────────
    systemPackages = with pkgs; [
      git
      curl
      vim
    ];
  };

  # ── Hyprland (compositor) ─────────────────────────────────────────────────
  # programs.hyprland.enable handles portals, polkit, xwayland, desktop entry
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true; # recommended: systemd session integration via UWSM
      xwayland.enable = true;
    };
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
    };
    steam.enable = true;
  };

  services = {
    # Display manager — SDDM on X11 (Wayland mode broken with NVIDIA/Weston)
    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
    };
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = false;
      };
      defaultSession = "hyprland-uwsm";
    };
    # ── Audio (Pipewire) ──────────────────────────────────────────────────────
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    # Disable PulseAudio — conflicts with Pipewire
    pulseaudio.enable = false;
    # ── SSH ───────────────────────────────────────────────────────────────────
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  security = {
    rtkit.enable = true;
    # Allow `sudo` for wheel group without password prompt during bootstrap
    # (tighten after first boot if preferred)
    sudo.wheelNeedsPassword = false;
  };

  # ── Logitech (Piper — MX Vertical mouse config) ───────────────────────────
  services.ratbagd.enable = true; # backend required by Piper

  # ── Bluetooth ─────────────────────────────────────────────────────────────
  # Disabled temporarily — was hanging boot
  # hardware.bluetooth.enable = true;
  # services.blueman.enable = true;

  # ── Docker ────────────────────────────────────────────────────────────────
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # ── Users ─────────────────────────────────────────────────────────────────
  # Password is set imperatively on first boot: `passwd alberto`
  users.users.alberto = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "video"
      "audio"
    ];
    # Public key for SSH login — private key lives on thumb drive
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8As8fHn8UykcTA4A3A81gBqBW/9WWzz7cEtaRW5h99 albertopluecker@gmail.com"
    ];
  };

  # ── Root password ─────────────────────────────────────────────────────────
  # Set imperatively: `sudo passwd root`
  # Declarative option (hashed): users.users.root.hashedPassword = "...";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
