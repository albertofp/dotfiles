# Rose Pine color palettes
# https://rosepinetheme.com/palette
#
# Usage in a module:
#   let theme = import ../lib/theme.nix; in
#   # theme.base, theme.foam, theme.moon.base, etc.
{
  # ── Rose Pine (main) ───────────────────────────────────────────────────────
  base = "#191724";
  surface = "#1f1d2e";
  overlay = "#26233a";
  muted = "#6e6a86";
  subtle = "#908caa";
  text = "#e0def4";
  love = "#eb6f92";
  gold = "#f6c177";
  rose = "#ebbcba";
  pine = "#31748f";
  foam = "#9ccfd8";
  iris = "#c4a7e7";
  highlightLow = "#21202e";
  highlightMed = "#403d52";
  highlightHigh = "#524f67";

  # ── Rose Pine Moon ─────────────────────────────────────────────────────────
  moon = {
    base = "#232136";
    surface = "#2a273f";
    overlay = "#393552";
    muted = "#6e6a86";
    subtle = "#908caa";
    text = "#e0def4";
    love = "#eb6f92";
    gold = "#f6c177";
    rose = "#ea9a97";
    pine = "#3e8fb0";
    foam = "#9ccfd8";
    iris = "#c4a7e7";
    highlightLow = "#2a283e";
    highlightMed = "#44415a";
    highlightHigh = "#56526e";
  };
}
