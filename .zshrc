[[ -f $HOME/.zshenv ]] && source $HOME/.zshenv

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY       # write timestamps
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_IGNORE_DUPS       # no consecutive duplicates
setopt HIST_IGNORE_SPACE      # don't record lines starting with space
setopt HIST_VERIFY            # don't execute immediately on history expansion
setopt SHARE_HISTORY          # share history across sessions

autoload -U compinit
compinit -i

if [[ -t 1 && -z "$TMUX" ]]; then
  tmux attach || tmux new
fi

export GOPATH="$HOME/go"
export GOMODCACHE="$GOPATH/pkg/mod"
if [[ $(uname -s) == "Darwin" ]]; then
  export GOCACHE="$HOME/Library/Caches/go-build"
else
  export GOCACHE="$HOME/.cache/go-build"
fi
export PATH="$PATH:$GOPATH/bin"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export KIND_EXPERIMENTAL_PROVIDER=podman

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export OPENSSL_CONF=/dev/null

export PERSONAL_EMAIL="albertopluecker@gmail.com"
export PERSONAL_SSH_KEY="$HOME/.ssh/id_home_github"
export WORK_EMAIL="alberto.pluecker@justeattakeaway.com"
export WORK_SSH_KEY="$HOME/.ssh/work_github"

if [[ -d ${HOME}/bin ]]; then
  export PATH=${HOME}/bin:$PATH
fi

export EDITOR="nvim"
export DOTFILES_DIR="$HOME/dotfiles"

alias rebuild="sudo nixos-rebuild switch --flake path:/home/alberto/dotfiles#alberto --impure"

alias kill9042='lsof -ti :9042 | xargs kill -9'
alias nvimconfig="nvim ~/.config/nvim/"
alias infnet="cd ~/INFNET/"
alias zshconfig="nvim ~/dotfiles/.zshrc"
alias tmuxconfig="nvim ~/dotfiles/.tmux.conf"
alias ghosttyconfig="nvim ~/dotfiles/.config/ghostty/config"
alias hyprconfig="nvim ~/dotfiles/.config/hypr/hyprland.conf"
alias reload="source ~/.zshrc"
alias n="nvim"
alias proj="cd $HOME/github/"
alias tf="terraform"
alias tg="terragrunt"

alias sync="ANSIBLE_PYTHON_INTERPRETER=auto_silent ansible-playbook ~/dotfiles/ansible/playbooks/bootstrap.yaml --connection=local --inventory=localhost, --forks=10"

alias gp="git push"
alias gs="git status"
alias gd="git diff"
alias ga="git add -p"
function git_commit_m {
 git commit -m "$*"
}
alias gc="git_commit_m"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gco="git checkout"
alias gcb="git checkout -b"
alias dog="git log --oneline --all --decorate --graph"
alias gg="git branch | fzf | xargs -n 1 git checkout"
alias gbd="git branch -D"
alias gpf="git push --force-with-lease"
alias gcpf="git add . && git commit --amend --no-edit && git push --force-with-lease"
alias glc="git log --oneline | head -n 1 | awk '{print \$1}' | tr -d '\n' | cut -c -7"
alias clc="git log --oneline | head -n 1 | awk '{print \$1}' |tr -d '\n' | cut -c -7 |pbcopy"
alias prw="gh pr view --web"
alias Prw="prw"
alias PRw="prw"
alias rw="gh repo view --web"
alias ghpc="gh pr create"
# alias merge="gh pr merge -sd --admin"
alias ghrw="gh run list --status=completed --limit 1| awk '{print \$6}'"

function copy_file_to_clipboard {
  if [ $1 != "" ];then
    cat $1|pbcopy
  fi
}
alias copy="copy_file_to_clipboard"

# Docker
alias dockerkill="docker stop \$(docker ps -a -q)"

alias k="kubectl"

alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"

alias lt="eza --tree --level=2 --long --icons"
alias ls="eza -l --icons"
alias la="eza  -l --icons -a"

# Kubectl autocomplete
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

if [[ $(uname -s) == "Darwin" ]]; then
  export HOMEBREW_NO_ENV_HINTS=1
  export HOMEBREW_NO_AUTO_UPDATE=1
  source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  export PATH=/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:$PATH
  source <(fzf --zsh)
  eval "$(starship init zsh)"
fi
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOPATH/bin
eval $(ssh-agent -s) > /dev/null 2>&1 && ssh-add -q $HOME/.ssh/id_home_github > /dev/null 2>&1

# ---- FZF ----
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
# ---- ----- ----

function mkcd takedir() {
  mkdir -p $@ && cd ${@:$#}
}

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
  cd "$(basename ${1%%.git})"
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ $(uname -s) == "Darwin" ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew
  export PKG_CONFIG_PATH="/opt/homebrew/bin/pkg-config:$(brew --prefix icu4c)/lib/pkgconfig:$(brew --prefix curl)/lib/pkgconfig:$(brew --prefix zlib)/lib/pkgconfig"
  export MACOSX_DEPLOYMENT_TARGET=15.5
fi

function aws-login() {
  local profile="${1}"
  if [[ -z "$profile" ]]; then
    echo "Usage: aws-login <profile-name>"
    return 1
  fi
  aws sso login --profile "${profile}" && \
  aws eks update-kubeconfig --profile "${profile}" --name "${profile}" --alias "${profile}"
}

# Login to SSO once and refresh kubeconfig for all EKS clusters.
# Usage: aws-login-all
function aws-login-all() {
  # --- Legacy SRE-EKS: profile → cluster name mapping ---
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

  # --- Sonic Runtime (OneEKS): profile name = cluster name ---
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
  for profile cluster_name in ${(kv)LEGACY_CLUSTERS}; do
    echo "    [legacy] profile=${profile} cluster=${cluster_name}"
    aws eks update-kubeconfig --profile "${profile}" --name "${cluster_name}" --alias "${cluster_name}" 2>&1
    if [[ $? -ne 0 ]]; then
      failed+=("${profile} (cluster: ${cluster_name})")
    fi
  done

  echo ""
  echo "==> Updating kubeconfig for Sonic Runtime (OneEKS) clusters..."
  for profile in "${SONIC_PROFILES[@]}"; do
    echo "    [sonic] profile=${profile}"
    aws eks update-kubeconfig --profile "${profile}" --name "${profile}" --alias "${profile}" 2>&1
    if [[ $? -ne 0 ]]; then
      failed+=("${profile}")
    fi
  done

  echo ""
  if [[ ${#failed[@]} -eq 0 ]]; then
    echo "==> Done. All kubeconfigs updated successfully."
  else
    echo "==> Done with errors. The following profiles failed:"
    for f in "${failed[@]}"; do
      echo "    - ${f}"
    done
  fi
}

autoload -U +X bashcompinit && bashcompinit
if [[ $(uname -s) != "Darwin" ]]; then
  # zsh-syntax-highlighting must be sourced last (after all zle widgets are set up)
  source /nix/store/*-zsh-syntax-highlighting-*/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ $(uname -s) == "Darwin" ]]; then
  complete -o nospace -C /opt/homebrew/bin/wizcli wizcli
fi
