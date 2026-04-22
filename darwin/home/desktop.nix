_:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # SSH: keys loaded from macOS Keychain on login; agent managed by launchd
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "home-server" = {
        hostname = "192.168.2.59";
        user = "alberto";
        identityFile = "~/.ssh/id_ed25519";
        addKeysToAgent = "yes";
        extraOptions.UseKeychain = "yes";
      };
      "seedbox" = {
        hostname = "216.163.184.165";
        user = "albertopluecker";
        identityFile = "~/.ssh/seedbox";
        addKeysToAgent = "yes";
        extraOptions.UseKeychain = "yes";
      };
      "github.je-labs.com" = {
        hostname = "github.je-labs.com";
        identityFile = "~/.ssh/work_github";
        addKeysToAgent = "yes";
        extraOptions.UseKeychain = "yes";
      };
      "*" = {
        identityFile = "~/.ssh/id_home_github";
        addKeysToAgent = "yes";
        extraOptions.UseKeychain = "yes";
      };
    };
  };
}
