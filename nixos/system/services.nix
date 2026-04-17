_:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  services.ratbagd.enable = true; # backend required by Piper (Logitech mouse config)

  # ── Bluetooth ──────────────────────────────────────────────────────────────
  # Disabled temporarily — was hanging boot
  # hardware.bluetooth.enable = true;
  # services.blueman.enable = true;
}
