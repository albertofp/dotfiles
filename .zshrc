# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $HOME/.zshenv

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/Library/Frameworks/Python.framework/Versions/3.10/bin:$PATH
export PATH=$CONDA_PREFIX/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

export PERSONAL_EMAIL="albertopluecker@gmail.com"
export WORK_EMAIL="alberto@cinference.bio"
export PERSONAL_SSH_KEY="$HOME/.ssh/id_home_github"
export WORK_SSH_KEY="$HOME/.ssh/id_work_github"

if [[ -d ${HOME}/bin ]]; then
  export PATH=${HOME}/bin:$PATH
fi

export EDITOR="nvim"
export DOTFILES_DIR="$HOME/dotfiles"
export PUBLISH_REPO="$HOME/website/src/content/blog"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

function toggle_github_user {
  if [[ "$(git config --global user.email)" == "$WORK_EMAIL" ]]; then
    echo "Setting GitHub email to $PERSONAL_EMAIL"
    git config --global user.email "$PERSONAL_EMAIL"
    ssh-add -q $PERSONAL_SSH_KEY
    ssh-add -q -d $WORK_SSH_KEY
  else
    echo "Setting GitHub email to $WORK_EMAIL"
    git config --global user.email "$WORK_EMAIL"
    ssh-add -q $WORK_SSH_KEY
    ssh-add -q -d $PERSONAL_SSH_KEY
  fi
}
# For Walk - https://github.com/antonmedv/walk
function lk {
  cd "$(walk "$@")"
}
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"
#
# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd.mm.yyyy"

plugins=(
  git
  kubectl
  archlinux
  colored-man-pages
  aliases
  command-not-found
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# :fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
 # alias cat="bat"
 alias tgu="toggle_github_user"
 alias nvimconfig="nvim ~/.config/nvim/"
 alias projects="cd ~/Desktop/Projects/"
 alias infnet="cd ~/INFNET/"
 alias zshconfig="nvim ~/dotfiles/.zshrc"
 alias kittyconfig="nvim ~/dotfiles/.config/kitty/kitty.conf"
 alias reload="source ~/.zshrc"
 alias ohmyzsh="nvim ~/.oh-my-zsh"
 alias vim="nvim"
 alias n="nvim"

 # Azure
 alias vmconnect="az ssh vm --resource-group cinference-rg --name alberto-01"
 alias vmssh="ssh -i ~/.ssh/alberto01.pem alberto@4.231.239.252  "
 alias vmstart="az vm start -g cinference-rg -n alberto-01"
 alias vmstop="az vm deallocate -g cinference-rg -n alberto-01"
 alias ccstart="az vm start -g cinference-rg -n cinference-cc"
 alias ccstop="az vm deallocate -g cinference-rg -n cinference-cc"
 alias ccssh="ssh -i ~/.ssh/cinference-cc_key.pem azureuser@cinference-cc.northeurope.cloudapp.azure.com"

 # alias air='~/.air'
  
 # Git
 
 get_branches() {
   gum choose --cursor="=> " $(git branch -a --format='%(refname:short)')
 }
 
 alias gp="git push"
 alias gs="git status"
 alias gd="git diff"
 alias ga="git add"
 alias gc="git commit -m"
 alias gca="git commit --amend"
 alias gcan="git commit --amend --no-edit"
 alias gco="git checkout"
 alias gcb="git checkout -b"
 alias dog="git log --oneline --all --decorate --graph"
 # alias gg="git branch | fzf | xargs -n 1 git checkout"
 alias gg="get_branches | xargs -n 1 git checkout"
 alias gpf="git push --force-with-lease"


 # Docker
 alias dockerkill="docker stop \$(docker ps -a -q)"

 alias ..="cd .."
 alias ...="cd ../../"
 alias ....="cd ../../../"

 # Kubernetes
 alias kfui="kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80"
 alias kfuir="ssh -L 8080:localhost:8080 -N -i ~/.ssh/alberto01.pem alberto@4.231.239.252"

 alias lt="eza --tree --level=2 --long --icons"
 alias ls="eza -l --icons"
 alias la="eza  -l --icons -a"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Kubectl autocomplete
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

if [[ $(uname -s) == "Darwin" ]]; then
  export GOPATH=/usr/local/go
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  export GOPATH=$HOME/go
  source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
 # maps caps lock to escape (shift+caps still works as caps lock)
  alias sce="setxkbmap -option \"caps:escape_shifted_capslock\"" 
fi
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOPATH/bin
eval $(ssh-agent -s) > /dev/null 2>&1 && ssh-add -q $HOME/.ssh/id_home_github > /dev/null 2>&1


export CONDA_PATH="$(find ~/ /opt/ -maxdepth 1 -mindepth 1 -type d -name "anaconda3" -print)"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$($CONDA_PATH 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_PATH/etc/profile.d/conda.sh" ]; then
        . "$CONDA_PATH/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_PATH/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

