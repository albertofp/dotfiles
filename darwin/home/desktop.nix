_:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # SSH: add keys on first use; agent managed by macOS keychain / launchd
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*".addKeysToAgent = "yes";
  };
}
