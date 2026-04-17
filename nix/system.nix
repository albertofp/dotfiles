{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  networking.hosts = {
    # Add custom /etc/hosts entries here, e.g.:
    # "192.168.1.100" = [ "mydevice.local" ];
  };

  # ── Locale / time ─────────────────────────────────────────────────────────
  time.timeZone                   = "Europe/Amsterdam";
  i18n.defaultLocale              = "en_US.UTF-8";

  # ── NVIDIA ────────────────────────────────────────────────────────────────
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable             = true;
    open                           = false;   # Pascal (GTX 1080) — open module not supported
    nvidiaSettings                 = true;
    package                        = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable         = false;
    powerManagement.finegrained    = false;
  };

  hardware.graphics.enable = true;

  # Required for NVIDIA + Wayland (Hyprland)
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelModules        = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.extraModulePackages  = [ config.boot.kernelPackages.nvidia_x11 ];

  # ── Hyprland (compositor) ─────────────────────────────────────────────────
  # programs.hyprland.enable handles portals, polkit, xwayland, desktop entry
  programs.hyprland = {
    enable          = true;
    xwayland.enable = true;
  };

  # Display manager — greetd + tuigreet (SDDM dropped: Weston/TTY issues with NVIDIA)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user    = "greeter";
      };
    };
  };
  # Suppress "getty conflict" noise on tty1
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # ── Audio (Pipewire) ──────────────────────────────────────────────────────
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    wireplumber.enable = true;
  };
  # Disable PulseAudio — conflicts with Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;

  # ── Bluetooth ─────────────────────────────────────────────────────────────
  # Disabled temporarily — was hanging boot
  # hardware.bluetooth.enable = true;
  # services.blueman.enable = true;

  # ── Docker ────────────────────────────────────────────────────────────────
  virtualisation.docker = {
    enable         = true;
    enableOnBoot   = true;
  };

  # ── SSH ───────────────────────────────────────────────────────────────────
  services.openssh = {
    enable          = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin        = "no";
    };
  };

  # ── Shell ─────────────────────────────────────────────────────────────────
  programs.zsh.enable = true;

  # ── Users ─────────────────────────────────────────────────────────────────
  # Password is set imperatively on first boot: `passwd alberto`
  users.users.alberto = {
    isNormalUser   = true;
    shell          = pkgs.zsh;
    extraGroups    = [ "wheel" "docker" "networkmanager" "video" "audio" ];

    # Public key for SSH login — private key lives on thumb drive
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8As8fHn8UykcTA4A3A81gBqBW/9WWzz7cEtaRW5h99 albertopluecker@gmail.com"
    ];
  };

  # Allow `sudo` for wheel group without password prompt during bootstrap
  # (tighten after first boot if preferred)
  security.sudo.wheelNeedsPassword = false;

  # ── Root password ─────────────────────────────────────────────────────────
  # Set imperatively: `sudo passwd root`
  # Declarative option (hashed): users.users.root.hashedPassword = "...";

  # ── System packages (minimal — user packages live in home.nix) ────────────
  environment.systemPackages = with pkgs; [
    git
    curl
    vim
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
