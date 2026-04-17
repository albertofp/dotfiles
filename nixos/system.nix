{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./system/nvidia.nix
    ./system/desktop.nix
    ./system/audio.nix
    ./system/networking.nix
    ./system/users.nix
    ./system/services.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    vim
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
