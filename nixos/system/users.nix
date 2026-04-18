{ pkgs, ... }:

{
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

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  programs.zsh.enable = true;
}
