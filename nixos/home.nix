_:

{
  imports = [
    ./home/packages.nix
    ./home/dotfiles.nix
    ./home/zsh.nix
    ./home/tmux.nix
    ./home/starship.nix
    ./home/desktop.nix
    ./home/hyprland.nix
    ./home/waybar.nix
    ./home/wlogout.nix
  ];

  home = {
    username = "alberto";
    homeDirectory = "/home/alberto";
    stateVersion = "24.11";

    sessionVariables = {
      EDITOR = "nvim";
      GOPATH = "$HOME/go";
      GOMODCACHE = "$HOME/go/pkg/mod";
      GOCACHE = "$HOME/.cache/go-build";
      DOTFILES_DIR = "$HOME/dotfiles";
      OPENSSL_CONF = "/dev/null";
      KIND_EXPERIMENTAL_PROVIDER = "podman";
      PERSONAL_EMAIL = "albertopluecker@gmail.com";
      PERSONAL_SSH_KEY = "$HOME/.ssh/id_home_github";
      WORK_EMAIL = "alberto.pluecker@justeattakeaway.com";
      WORK_SSH_KEY = "$HOME/.ssh/work_github";
      FZF_DEFAULT_OPTS = ''
        --color=fg:#908caa,bg:#191724,hl:#ebbcba
        --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
        --color=border:#403d52,header:#31748f,gutter:#191724
        --color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
        --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa'';
    };

    sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
      "$HOME/go/bin"
      "\${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
    ];
  };

  programs.home-manager.enable = true;
}
