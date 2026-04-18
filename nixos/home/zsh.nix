_:

{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake path:/home/alberto/dotfiles#alberto --impure";

      # Editors
      n = "nvim";
      nvimconfig = "nvim ~/.config/nvim/";
      ghosttyconfig = "nvim ~/dotfiles/.config/ghostty/config";
      nixedit = "nvim ~/dotfiles/nixos/";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      proj = "cd $HOME/github/";

      # Git
      gp = "git push";
      gs = "git status";
      gd = "git diff";
      ga = "git add -p";
      gc = "git_commit_m";
      gca = "git commit --amend";
      gcan = "git commit --amend --no-edit";
      gco = "git checkout";
      gcb = "git checkout -b";
      dog = "git log --oneline --all --decorate --graph";
      gg = "git branch | fzf | xargs -n 1 git checkout";
      gbd = "git branch -D";
      gpf = "git push --force-with-lease";
      gcpf = "git add . && git commit --amend --no-edit && git push --force-with-lease";
      glc = "git log --oneline | head -n 1 | awk '{print $1}' | tr -d '\n' | cut -c -7";
      prw = "gh pr view --web";
      Prw = "gh pr view --web";
      PRw = "gh pr view --web";
      rw = "gh repo view --web";
      ghpc = "gh pr create";
      ghrw = "gh run list --status=completed --limit 1| awk '{print $6}'";

      # Files
      lt = "eza --tree --level=2 --long --icons";
      ls = "eza -l --icons";
      la = "eza -l --icons -a";

      # Tools
      k = "kubectl";
      tf = "terraform";
      tg = "terragrunt";
      kill9042 = "lsof -ti :9042 | xargs kill -9";
      dockerkill = "docker stop $(docker ps -a -q)";
    };

    initContent = ''
      # Auto-attach to tmux on interactive shells
      if [[ -t 1 && -z "$TMUX" ]]; then
        tmux attach || tmux new
      fi

      # Secrets (API keys, tokens — decrypted by agenix at boot)
      [[ -f /run/agenix/shell-secrets ]] && source /run/agenix/shell-secrets

      # kubectl completion
      [[ $commands[kubectl] ]] && source <(kubectl completion zsh)

      # bashcompinit (needed for some CLI completions e.g. terraform)
      autoload -U +X bashcompinit && bashcompinit

      # Git commit helper
      function git_commit_m { git commit -m "$*" }

      # mkdir + cd
      function takedir() { mkdir -p $@ && cd ''${@:$#} }

      function takeurl() {
        local data thedir
        data="$(mktemp)"
        curl -L "$1" > "$data"
        tar xf "$data"
        thedir="$(tar tf "$data" | head -n 1)"
        rm "$data"
        cd "$thedir"
      }

      function takegit() {
        git clone "$1"
        cd "$(basename ''${1%%.git})"
      }

      function take() {
        if [[ $1 =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]; then
          takeurl "$1"
        elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
          takegit "$1"
        else
          takedir "$@"
        fi
      }
    '';
  };
}
