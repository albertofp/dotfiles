let
  # Your personal SSH key — used to encrypt/edit secrets locally
  alberto = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8As8fHn8UykcTA4A3A81gBqBW/9WWzz7cEtaRW5h99 albertopluecker@gmail.com";

  # Host SSH key — used to decrypt secrets at boot
  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPRZuJNqfOC8scNQnA/MQeji+k1bMNJYSMYnFhuDwpZN root@nixos";

  allKeys = [
    alberto
    nixos
  ];
in
{
  # Shell environment secrets (API keys, tokens, etc.)
  # Decrypted to /run/agenix/shell-secrets and sourced by zsh on login.
  "shell-secrets.age".publicKeys = allKeys;
}
