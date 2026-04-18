_:

let
  t = import ../lib/theme.nix;
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$character";
      right_format = "$all";
      palette = "rose-pine";
      command_timeout = 1000;

      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
        vimcmd_symbol = "[](bold green) ";
      };

      directory = {
        style = "foam";
        read_only = " 󰌾";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        format = "[$symbol$branch ]($style)";
        disabled = false;
        ignore_branches = [
          "master"
          "main"
        ];
      };

      git_status = {
        ignore_submodules = true;
        style = "rose";
        stashed = "*\${count}";
        modified = "!\${count}";
        staged = "+\${count}";
        untracked = "?\${count}";
        deleted = "✘\${count}";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇡\${ahead_count}⇣\${behind_count}";
      };

      golang = {
        disabled = false;
        format = "[$symbol($version )]($style)";
        style = "bold blue";
        symbol = " ";
      };

      python = {
        symbol = " ";
        style = "gold bold";
        format = "[\${symbol}\${pyenv_prefix}(\${version} )(\(\${virtualenv}\) )]($style)";
      };

      c = {
        symbol = " ";
        format = "[$symbol($version(-$name) )]($style)";
      };

      kubernetes = {
        symbol = "󱃾 ";
        disabled = false;
        format = "[$symbol$context( \\($namespace\\))](bold $style) ";
        contexts = [
          {
            context_pattern = "gke_justwatch-compute_europe-west1-d_jw-k8s-prod-eu-2";
            style = "foam";
            context_alias = "prod";
          }
          {
            context_pattern = "gke_justwatch-compute_europe-west1-b_jw-k8s-stage-eu-2";
            style = "iris";
            context_alias = "stage";
          }
        ];
      };

      terraform.disabled = true;
      buf.disabled = true;
      docker_context = {
        disabled = true;
        symbol = " ";
      };
      gcloud = {
        symbol = "󱇶 ";
        disabled = true;
      };
      aws = {
        symbol = "  ";
        disabled = true;
      };
      time = {
        disabled = true;
        format = "[$time]($style) ";
        style = "subtle";
      };
      line_break.disabled = true;

      nodejs = {
        style = "green";
        format = "[$symbol$version](green) ";
      };
      package = {
        symbol = "󰏗 ";
        format = "[$symbol$version](208 bold) ";
      };

      palettes.rose-pine = {
        inherit (t)
          base
          surface
          overlay
          muted
          subtle
          text
          love
          gold
          rose
          pine
          foam
          iris
          ;
        highlight_low = t.highlightLow;
        highlight_med = t.highlightMed;
        highlight_high = t.highlightHigh;
      };
    };
  };
}
