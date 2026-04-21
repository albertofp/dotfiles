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
    matchBlocks."github.je-labs.com" = {
      hostname = "github.je-labs.com";
      identityFile = "~/.ssh/work_github";
      addKeysToAgent = "yes";
      extraOptions.UseKeychain = "yes";
    };
    matchBlocks."*" = {
      identityFile = "~/.ssh/id_home_github";
      addKeysToAgent = "yes";
      extraOptions.UseKeychain = "yes";
    };
  };
}
