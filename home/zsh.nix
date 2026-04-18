{ pkgs, ... }:

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
      # Editors
      n = "nvim";
      nvimconfig = "nvim ~/.config/nvim/";
      ghosttyconfig = "nvim ~/dotfiles/.config/ghostty/config";

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
    }
    // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
      rebuild = "sudo nixos-rebuild switch --flake path:/home/alberto/dotfiles#alberto --impure";
      nixedit = "nvim ~/dotfiles/nixos/";
    }
    // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
      rebuild = "sudo darwin-rebuild switch --flake path:/Users/albertopluecker/dotfiles#alberto-mac --impure";
      nixedit = "nvim ~/dotfiles/";
      reload = "source ~/.zshrc";
      # Copy last git commit hash to clipboard
      clc = "git log --oneline | head -n 1 | awk '{print $1}' | tr -d '\n' | cut -c -7 | pbcopy";
      copy = "copy_file_to_clipboard";
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
    ''
    + pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
      # macOS: copy file to clipboard
      function copy_file_to_clipboard() {
        [[ -n "$1" ]] && cat "$1" | pbcopy
      }

      # AWS SSO login helper
      function aws-login() {
        local profile="''${1}"
        if [[ -z "$profile" ]]; then
          echo "Usage: aws-login <profile-name>"
          return 1
        fi
        aws sso login --profile "''${profile}" && \
        aws eks update-kubeconfig --profile "''${profile}" --name "''${profile}" --alias "''${profile}"
      }

      # AWS SSO login + kubeconfig for all clusters
      function aws-login-all() {
        local -A LEGACY_CLUSTERS=(
          [infra-eks-dev-1]="eks-cluster-dev"
          [sre-eks-dev-1]="eks-cluster-dev"
          [sre-eks-migration-1]="eks-cluster-dev"
          [sre-eks-staging-1]="eks-cluster-staging-2"
          [sre-eks-production-1]="eks-cluster-prod"
          [sre-eks-gitlab-1]="eks-cluster-prod"
          [sre-eks-intsvc-1]="eks-cluster-prod"
          [p-ew1-dreks]="p-ew1-dreks"
        )

        local SONIC_PROFILES=(
          euw1-pdv-sbx-2
          euw1-pdv-qa-2
          euw1-pdv-qa-3
          euw1-pdv-stg-5
          euw1-pdv-stg-6
          euw1-pdv-prd-5
          euw1-pdv-prd-6
          usw2-pdv-qa-1
          usw2-pdv-stg-1
          usw2-pdv-prd-2
          apse2-pdv-qa-2
          apse2-pdv-stg-2
          apse2-pdv-prd-3
          euw1-plt-stg-2
          euw1-plt-prd-2
          usw2-plt-prd-2
          apse2-plt-prd-1
          euw1-pmt-stg-1
          euw1-pmt-prd-1
          apse2-pmt-stg-1
          apse2-pmt-prd-1
        )

        echo "==> Logging in to AWS SSO (orga portal)..."
        aws sso login --profile orga
        if [[ $? -ne 0 ]]; then
          echo "ERROR: SSO login failed. Aborting."
          return 1
        fi

        local failed=()

        echo ""
        echo "==> Updating kubeconfig for legacy SRE-EKS clusters..."
        for profile cluster_name in ''${(kv)LEGACY_CLUSTERS}; do
          echo "    [legacy] profile=''${profile} cluster=''${cluster_name}"
          aws eks update-kubeconfig --profile "''${profile}" --name "''${cluster_name}" --alias "''${cluster_name}" 2>&1
          [[ $? -ne 0 ]] && failed+=("''${profile} (cluster: ''${cluster_name})")
        done

        echo ""
        echo "==> Updating kubeconfig for Sonic Runtime (OneEKS) clusters..."
        for profile in "''${SONIC_PROFILES[@]}"; do
          echo "    [sonic] profile=''${profile}"
          aws eks update-kubeconfig --profile "''${profile}" --name "''${profile}" --alias "''${profile}" 2>&1
          [[ $? -ne 0 ]] && failed+=("''${profile}")
        done

        echo ""
        if [[ ''${#failed[@]} -eq 0 ]]; then
          echo "==> Done. All kubeconfigs updated successfully."
        else
          echo "==> Done with errors. The following profiles failed:"
          for f in "''${failed[@]}"; do echo "    - ''${f}"; done
        fi
      }

      # wizcli completion (requires wizcli in home.packages)
      complete -o nospace -C wizcli wizcli
    '';
  };
}
