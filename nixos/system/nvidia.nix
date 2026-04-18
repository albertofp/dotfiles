{ config, ... }:

{
  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # Pascal (GTX 1080) — open module not supported
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  hardware.graphics.enable = true;

  # Required for NVIDIA + Wayland (Hyprland)
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  # Load nvidia modules early so KMS is available before display manager starts.
  # btusb is loaded here too — without early loading it can hang boot on NVIDIA systems.
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
    "btusb"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  # Mesa 25.x loads nvidia-drm_gbm.so which crashes with legacy_535.
  # Override the GBM backend path to use only Mesa's own implementation.
  environment.variables.GBM_BACKEND = "drm";
}
