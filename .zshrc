source $HOME/.zshenv
autoload -U compinit
compinit -i

if [ "$TMUX" = "" ]; then tmux; fi

export GOPATH="$HOME/go"
export GOMODCACHE="$GOPATH/pkg/mod"
export GOCACHE="$HOME/Library/Caches/go-build"
export PATH="$PATH:$GOPATH/bin"

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export OPENSSL_CONF=/dev/null

export PERSONAL_EMAIL="albertopluecker@gmail.com"
export PERSONAL_SSH_KEY="$HOME/.ssh/id_home_github"

if [[ -d ${HOME}/bin ]]; then
  export PATH=${HOME}/bin:$PATH
fi

export EDITOR="nvim"
export DOTFILES_DIR="$HOME/dotfiles"
export PUBLISH_REPO="$HOME/website/src/content/blog"

alias kill9042='lsof -ti :9042 | xargs kill -9'
alias nvimconfig="nvim ~/.config/nvim/"
alias infnet="cd ~/INFNET/"
alias zshconfig="nvim ~/dotfiles/.zshrc"
alias tmuxconfig="nvim ~/dotfiles/.tmux.conf"
alias ghosttyconfig="nvim ~/dotfiles/.config/ghostty/config"
alias hyprconfig="nvim ~/dotfiles/.config/hypr/hyprland.conf"
alias reload="source ~/.zshrc"
alias n="nvim"
alias proj="cd ~/github/"
alias tf="terraform"

alias avedit="ansible-vault edit --vault-password-file ~/.ansible_vault_pass.txt"
alias avenc="ansible-vault encrypt --vault-password-file ~/.ansible_vault_pass.txt --encrypt-vault-id default"
alias avdec="ansible-vault decrypt --vault-password-file ~/.ansible_vault_pass.txt"
alias sync="ANSIBLE_PYTHON_INTERPRETER=auto_silent ansible-playbook ~/dotfiles/ansible/playbooks/bootstrap.yaml --connection=local --inventory=localhost, --ask-become-pass--forks=10 --vault-password-file=~/.ansible_vault_pass.txt"

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
alias ghpc="gh pr create --fill"
alias merge="gh pr merge -sd --admin"
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
else
  alias task="go-task"
  export GOPATH=$HOME/go
  source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOPATH/bin
eval $(ssh-agent -s) > /dev/null 2>&1 && ssh-add -q $HOME/.ssh/id_home_github > /dev/null 2>&1

# ---- FZF ----
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
source <(fzf --zsh)
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

# /usr/local/share/google-cloud-sdk
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/share/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/share/google-cloud-sdk/path.zsh.inc'; fi
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/share/google-cloud-sdk/completion.zsh.inc'; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export HOMEBREW_PREFIX=/opt/homebrew
export PKG_CONFIG_PATH="/opt/homebrew/bin/pkg-config:$(brew --prefix icu4c)/lib/pkgconfig:$(brew --prefix curl)/lib/pkgconfig:$(brew --prefix zlib)/lib/pkgconfig"
export MACOSX_DEPLOYMENT_TARGET=15.5

eval "$(starship init zsh)"
