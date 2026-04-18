let
  t = import ./lib/theme.nix;
in
_: {
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
    ./home/wallpaper.nix
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
      FZF_DEFAULT_OPTS = ''
        --color=fg:${t.subtle},bg:${t.base},hl:${t.rose}
        --color=fg+:${t.text},bg+:${t.overlay},hl+:${t.rose}
        --color=border:${t.highlightMed},header:${t.pine},gutter:${t.base}
        --color=spinner:${t.gold},info:${t.foam},separator:${t.highlightMed}
        --color=pointer:${t.iris},marker:${t.love},prompt:${t.subtle}'';
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
