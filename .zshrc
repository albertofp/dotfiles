source $HOME/.zshenv
autoload -U compinit
compinit -i

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

export PERSONAL_EMAIL="albertopluecker@gmail.com"
export WORK_EMAIL="alberto.pluecker@justwatch.com"
export PERSONAL_SSH_KEY="$HOME/.ssh/id_home_github"
# export WORK_SSH_KEY="$HOME/.ssh/id_work_github"

export HOMEBBREW_NO_ENV_HINTS=1

if [[ -d ${HOME}/bin ]]; then
  export PATH=${HOME}/bin:$PATH
fi

export GOPRIVATE=github.com/justwatch,jus.tw.cx
export GONOPROXY=github.com/justwatch,jus.tw.cx
export GONOSUMDB=github.com/justwatch,jus.tw.cx
export EDITOR="nvim"
export DOTFILES_DIR="$HOME/dotfiles"
export PUBLISH_REPO="$HOME/website/src/content/blog"

 alias kill8000='lsof -ti :8000 | xargs kill -9'
 alias nvimconfig="nvim ~/.config/nvim/"
 alias infnet="cd ~/INFNET/"
 alias zshconfig="nvim ~/dotfiles/.zshrc"
 alias kittyconfig="nvim ~/dotfiles/.config/kitty/kitty.conf"
 alias ghosttyconfig="nvim ~/dotfiles/.config/ghostty/config"
 alias reload="source ~/.zshrc"
 alias n="nvim"
 alias jw="cd ~/justwatch/"
 alias proj="cd ~/github/"
 alias tf="terraform"

 alias avedit="ansible-vault edit --vault-password-file ~/.ansible_vault_pass.txt"
 alias avenc="ansible-vault encrypt --vault-password-file ~/.ansible_vault_pass.txt --encryt-vault-id default"
 alias avdec="ansible-vault decrypt --vault-password-file ~/.ansible_vault_pass.txt"

 alias argoprod="kubectl --context=gke_justwatch-compute_europe-west1-d_jw-k8s-prod-eu-2 port-forward svc/argocd-server -n argocd 8080:443"
 alias argopw="kubectl -n argocd get secret argocd-secret -o json | jq -r '.data[\"admin.password\"]' | base64 --decode"
 
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
 alias gpf="git push --force-with-lease"
 alias glc="git log --oneline | head -n 1 | awk '{print \$1}'"
 alias clc="git log --oneline | head -n 1 | awk '{print \$1}' |tr -d '\n' |pbcopy"
 alias prw="gh pr view --web"
 alias rw="gh repo view --web"

 function copy_file_to_clipboard {
   if [ $1 != "" ];then
     cat $1|pbcopy
   fi
 }
 alias copy="copy_file_to_clipboard"

 # Docker
 alias dockerkill="docker stop \$(docker ps -a -q)"

 alias k="kubectl"
 alias kp="kubectl --context=gke_justwatch-compute_europe-west1-d_jw-k8s-prod-eu-2"
 alias ks="kubectl --context=gke_justwatch-compute_europe-west1-b_jw-k8s-stage-eu-2"
 alias kp9="k9s --context gke_justwatch-compute_europe-west1-d_jw-k8s-prod-eu-2"
 alias ks9="k9s --context gke_justwatch-compute_europe-west1-b_jw-k8s-stage-eu-2"

 alias ..="cd .."
 alias ...="cd ../../"
 alias ....="cd ../../../"

 alias lt="eza --tree --level=2 --long --icons"
 alias ls="eza -l --icons"
 alias la="eza  -l --icons -a"

# Kubectl autocomplete
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

if [[ $(uname -s) == "Darwin" ]]; then
  export GOPATH=/usr/local/go
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  alias task="go-task"
  export GOPATH=$HOME/go
  source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
 # maps caps lock to escape (shift+caps still works as caps lock)
  alias sce="setxkbmap -option \"caps:escape_shifted_capslock\"" 
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
if [ -f '/home/albertofp/google-cloud-sdk/path.zsh.inc' ]; then . '/home/albertofp/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/share/google-cloud-sdk/completion.zsh.inc'; fi
if [ -f '/home/albertofp/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/albertofp/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(starship init zsh)"
