_:

let
  t = import ../nixos/lib/theme.nix;
in
{
  programs.home-manager.enable = true;

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      GOPATH = "$HOME/go";
      GOMODCACHE = "$HOME/go/pkg/mod";
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
    ];
  };
}
